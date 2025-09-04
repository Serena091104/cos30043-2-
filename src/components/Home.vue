<template>
  <div class="home container mt-4">
    <!-- Hero Section -->
    <div class="jumbotron p-4 bg-light rounded mb-4 text-center">
      Welcome, {{ loggedInUser?.username || 'Guest' }}! We hope you have a lovely experience with us.
      <p class="lead">
        Welcome to our website. Here you can find beauty products and add them to your shopping cart. Enjoy your shopping!
      </p>
      <button v-if="loggedInUser" class="btn btn-danger" @click="logout">Logout</button>
    </div>

    <div class="row">
      <!-- Sidebar Category Filter -->
      <aside class="col-md-3 mb-4">
        <h5>Categories</h5>
        <ul class="list-group">
          <li
            class="list-group-item"
            :class="{ active: selectedCategory === '' }"
            @click="selectedCategory = ''"
            style="cursor: pointer;"
          >
            All Categories
          </li>
          <li
            v-for="cat in uniqueCategories"
            :key="cat"
            class="list-group-item"
            :class="{ active: selectedCategory === cat }"
            @click="selectedCategory = cat"
            style="cursor: pointer;"
          >
            {{ cat }}
          </li>
        </ul>
      </aside>

      <!-- Products Section -->
      <section class="col-md-9">
        <!-- Search input above products -->
        <div class="mb-3">
          <input
            type="text"
            class="form-control"
            placeholder="Search for products..."
            v-model="searchQuery"
          />
        </div>

        <h2>Our Products</h2>
        <div class="row">
          <div
            class="col-12 col-sm-6 col-lg-4 mb-4"
            v-for="product in paginatedProducts"
            :key="product.id"
          >
            <div class="card h-100 product-card">
              <img
                :src="product.image"
                class="card-img-top"
                :alt="product.title"
              />
              <div class="card-body d-flex flex-column">
                <h5 class="card-title">{{ product.title }}</h5>
                <p class="card-text text-truncate mb-2">
                  {{ product.description.length > 100
                    ? product.description.slice(0, 100) + '...'
                    : product.description }}
                </p>
                <p class="card-text mb-1">
                  <strong>${{ parseFloat(product.price).toFixed(2) }}</strong>
                </p>
                <p class="text-muted mb-3">Likes: {{ likes[product.id] || 0 }}</p>

                <div v-if="loggedInUser" class="mt-auto">
                  <button
                    class="btn btn-outline-primary me-2"
                    @click="likeProduct(product)"
                  >
                    Like
                  </button>
                  <button
                    class="btn btn-outline-info mt-2"
                    @click="buyNow(product)"
                  >
                    Buy Now
                  </button>
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
      </section>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue';
import Pagination from '../components/Pagination.vue';
import productsData from '../data/product.json'; // Local JSON file

const loggedInUser = ref({ username: 'Serena' }); // Demo user
const products = ref([]);
const searchQuery = ref('');
const selectedCategory = ref('');
const currentPage = ref(1);
const perPage = ref(6);
const likes = ref({});

onMounted(() => {
  products.value = productsData.map((prod, index) => ({
    id: prod.id || index,
    title: prod.name,
    ...prod,
  }));
});

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
  return filteredProducts.value.slice(start, start + perPage.value);
});

const uniqueCategories = computed(() => {
  return [...new Set(products.value.map(p => p.category).filter(Boolean))];
});

function likeProduct(product) {
  if (!loggedInUser.value) {
    alert('Please log in to like products.');
    return;
  }
  likes.value[product.id] = (likes.value[product.id] || 0) + 1;
}

function buyNow(product) {
  alert(`Successfully purchased ${product.title}!\nThank you for your purchase!`);
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
  display: flex;
  flex-direction: column;
}
.product-card:hover {
  transform: translateY(-10px);
  box-shadow: 0 10px 20px rgba(0, 0, 0, 0.2);
}
.list-group-item {
  cursor: pointer;
}
.list-group-item.active {
  background-color: #0d6efd;
  border-color: #0d6efd;
  color: white;
}
</style>
