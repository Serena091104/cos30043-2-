<template>
  <div class="home">
    <!-- Hero Section -->
    <div class="jumbotron p-4 bg-light rounded mt-3">
      Welcome, {{ loggedInUser?.username || 'Guest' }}! We hope to have a lovely experience with us.
      <p class="lead">
        Welcome to our website. Here you can find beauty products and add them to your shopping cart. Enjoy your shopping!
      </p>
      <button v-if="loggedInUser" class="btn btn-danger" @click="logout">Logout</button>
    </div>

    <!-- Search and Filter -->
    <div class="input-group mb-3">
      <input type="text" class="form-control" placeholder="Search for products..." v-model="searchQuery" />
      <select class="form-select" v-model="selectedCategory">
        <option value="">All Categories</option>
        <option v-for="cat in uniqueCategories" :key="cat" :value="cat">{{ cat }}</option>
      </select>
    </div>

    <!-- Products Section -->
    <div class="row mt-5">
      <div class="col-12">
        <h2>Our Products</h2>

        <!-- Product Cards -->
        <div class="row">
          <div class="col-12 col-md-6 col-lg-4 mb-4" v-for="product in paginatedProducts" :key="product.id">
            <div class="card h-100 product-card">
              <img :src="product.image" class="card-img-top" :alt="product.title || 'Product image'" />
              <div class="card-body">
                <h5 class="card-title">{{ product.title }}</h5>
                <p class="card-text text-truncate">
                  {{ product.description.length > 100 ? product.description.slice(0, 100) + '...' : product.description }}
                </p>
                <p class="card-text"><strong>${{ product.price.toFixed(2) }}</strong></p>

                <p class="text-muted mb-1">Likes: {{ likes[product.id] || 0 }}</p>

                <div v-if="loggedInUser">
                  <button class="btn btn-outline-primary me-2" @click="likeProduct(product.id)">Like</button>
                  <button class="btn btn-outline-info mt-2" @click="buyNow(product)">Buy Now</button>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Pagination -->
        <Pagination
          :total-items="filteredProducts.length"
          :per-page="perPage"
          :current-page="currentPage"
          @pageChanged="handlePageChange"
        />
      </div>
    </div>
  </div>
</template>

<script>
import Pagination from '../components/Pagination.vue';

const proxyBase = "https://cors-proxy-production-99.up.railway.app";
const baseURL = "https://myproject1.infinityfreeapp.com/resource";

export default {
  name: 'HomePage',
  components: { Pagination },
  data() {
    return {
      loggedInUser: null,
      products: [],
      searchQuery: '',
      selectedCategory: '',
      currentPage: 1,
      perPage: 6,
      likes: {},
    };
  },
  computed: {
    filteredProducts() {
      return this.products.filter(product => {
        const matchesSearch =
          product.title.toLowerCase().includes(this.searchQuery.toLowerCase()) ||
          product.description.toLowerCase().includes(this.searchQuery.toLowerCase());
        const matchesCategory = this.selectedCategory === '' || product.category === this.selectedCategory;
        return matchesSearch && matchesCategory;
      });
    },
    paginatedProducts() {
      const start = (this.currentPage - 1) * this.perPage;
      const end = start + this.perPage;
      return this.filteredProducts.slice(start, end);
    },
    uniqueCategories() {
      return [...new Set(this.products.map(p => p.category))].filter(Boolean);
    },
  },
  methods: {
    async fetchSession() {
      try {
        const targetURL = `${baseURL}/api_user.php`;
        const response = await fetch(`${proxyBase}?url=${encodeURIComponent(targetURL)}`);
        const data = await response.json();
        if (data.logged_in) {
          this.loggedInUser = { user_id: data.user_id, username: data.username };
        } else {
          this.loggedInUser = null;
        }
      } catch (error) {
        console.error('Error fetching session:', error);
      }
    },
    async likeProduct(productId) {
      if (!this.loggedInUser) {
        alert('Please log in to like products.');
        return;
      }
      try {
        const targetURL = `${baseURL}/api_like.php`;
        const response = await fetch(`${proxyBase}?url=${encodeURIComponent(targetURL)}`, {
          method: 'POST',
          headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
          body: new URLSearchParams({ product_id: productId }),
        });
        const data = await response.json();
        if (data.status === 'success') {
          this.likes[productId] = data.likes_count;
          alert(`Mercury said '${data.message}'`);
        } else {
          console.error('Error liking product:', data.message);
        }
      } catch (error) {
        console.error('Error liking product:', error);
      }
    },
    buyNow(product) {
      alert(`Successfully purchased ${product.title}!\nThank you for your purchase!`);
    },
    async logout() {
      try {
        const targetURL = `${baseURL}/api_user.php`;
        const response = await fetch(`${proxyBase}?url=${encodeURIComponent(targetURL)}`, {
          method: 'DELETE',
        });
        const data = await response.json();
        if (data.success) {
          this.loggedInUser = null;
          this.$router.push('/login');
        }
      } catch (error) {
        console.error('Error logging out:', error);
      }
    },
    async fetchProducts() {
      try {
        const targetURL = `${baseURL}/api2.php`;
        const res = await fetch(`${proxyBase}?url=${encodeURIComponent(targetURL)}`);
        const data = await res.json();

        this.products = data.map(product => ({
          ...product,
          price: typeof product.price === 'number' ? product.price : parseFloat(product.price) || 0,
        }));

        // Fetch initial likes count for each product
        for (const product of this.products) {
          const likesURL = `${baseURL}/api_like.php?product_id=${product.id}`;
          const likesRes = await fetch(`${proxyBase}?url=${encodeURIComponent(likesURL)}`);
          const likesData = await likesRes.json();
          if (likesData && likesData.status === 'success') {
            this.likes[product.id] = likesData.likes_count || 0;
          }
        }
      } catch (error) {
        console.error('Error fetching products:', error);
      }
    },
    handlePageChange(newPage) {
      this.currentPage = newPage;
    },
  },
  async mounted() {
    await this.fetchSession();
    await this.fetchProducts();
  },
};
</script>

<style scoped>
.jumbotron {
  background: linear-gradient(to right, #ffe3ec, #fceabb);
  padding: 2.5rem;
  border-radius: 1rem;
  text-align: center;
  color: #333;
  box-shadow: 0 0.75rem 2rem rgba(0, 0, 0, 0.1);
}

.card-img-top {
  height: 220px;
  object-fit: cover;
  border-top-left-radius: 1.25rem;
  border-top-right-radius: 1.25rem;
}

.product-card {
  transition: transform 0.3s ease, box-shadow 0.3s ease;
  cursor: pointer;
}

.product-card:hover {
  transform: translateY(-10px);
  box-shadow: 0 10px 20px rgba(0, 0, 0, 0.2);
}
</style>
