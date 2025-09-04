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
          <div class="col-12 col-md-6 col-lg-4 mb-4" v-for="product in paginatedProducts" :key="product.id || product.name">
            <div class="card h-100 product-card">
              <img :src="product.image" class="card-img-top" :alt="product.title || product.name" />
              <div class="card-body">
                <h5 class="card-title">{{ product.title || product.name }}</h5>
                <p class="card-text text-truncate">
                  {{ product.description.length > 100 ? product.description.slice(0, 100) + '...' : product.description }}
                </p>
                <p class="card-text"><strong>${{ parseFloat(product.price).toFixed(2) }}</strong></p>

                <div v-if="loggedInUser">
                  <button class="btn btn-outline-primary me-2" @click="likeProduct(product)">Like</button>
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

<script setup>
import { ref, computed, onMounted } from 'vue';
import Pagination from '../components/Pagination.vue';
import productsData from '../data/products.json'; // Import the JSON data

const loggedInUser = ref(null); // Replace with actual user logic
const products = ref([]);
const searchQuery = ref('');
const selectedCategory = ref('');
const currentPage = ref(1);
const perPage = ref(6);
const likes = ref({});

// Load products on mount
onMounted(() => {
  // Wrap JSON format to match existing code expectations
  products.value = productsData.map((prod, index) => ({
    id: prod.id || index,
    title: prod.name,
    ...prod
  }));
});

// Computed filters & pagination
const filteredProducts = computed(() => {
  return products.value.filter(product => {
    const matchesSearch =
      product.title.toLowerCase().includes(searchQuery.value.toLowerCase()) ||
      product.description.toLowerCase().includes(searchQuery.value.toLowerCase());
    const matchesCategory =
      !selectedCategory.value || product.category === selectedCategory.value;
    return matchesSearch && matchesCategory;
  });
});

const paginatedProducts = computed(() => {
  const start = (currentPage.value - 1) * perPage.value;
  const end = start + perPage.value;
  return filteredProducts.value.slice(start, end);
});

const uniqueCategories = computed(() => {
  return [
    ...new Set(products.value.map(p => p.category).filter(Boolean))
  ];
});

// Handlers
function likeProduct(product) {
  if (!loggedInUser.value) return alert('Please log in to like products.');
  likes.value[product.id] = (likes.value[product.id] || 0) + 1;
}

function buyNow(product) {
  alert(`Successfully purchased ${product.title}! Thank you for your purchase.`);
}

function handlePageChange(newPage) {
  currentPage.value = newPage;
}

function logout() {
  loggedInUser.value = null;
}
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
}
.product-card:hover {
  transform: translateY(-10px);
  box-shadow: 0 10px 20px rgba(0, 0, 0, 0.2);
}
</style>
