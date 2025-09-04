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
                      <button class="btn btn-outline-secondary me-2" @click="toggleCommentBox(product.id)">Comments</button>
                      <button class="btn btn-outline-info mt-2" @click="buyNow(product)">Buy Now</button>
                    </div>

                    <!-- Comments Section -->
                    <div v-if="visibleComments[product.id]" class="mt-3">
                      <h6>Comments:</h6>
                      <div
                        v-for="(comment, index) in comments[product.id] || []"
                        :key="index"
                        class="mb-2"
                      >
                        <strong>{{ comment.username }}</strong>: {{ comment.comment }}
                        <small class="text-muted">({{ comment.created_at }})</small>
                        <button
                          v-if="loggedInUser && comment.user_id === loggedInUser.user_id"
                          class="btn btn-sm btn-danger ms-2"
                          @click.stop="deleteComment(comment.id, product.id)"
                        >
                          Delete
                        </button>
                      </div>
                      <div v-if="loggedInUser" class="mt-2">
                        <input
                          type="text"
                          class="form-control"
                          v-model="newCommentText[product.id]"
                          placeholder="Add a comment..."
                          @keyup.enter="addComment(product.id)"
                        />
                      </div>
                      <div v-else>
                        <p class="text-muted">Log in to add comments.</p>
                      </div>
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
      </section>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue';
import Pagination from '../components/Pagination.vue';
import productsData from '../data/product.json'; // Local JSON file

const loggedInUser = ref({ username: 'Serena', user_id: 1 }); // Added user_id for comments
const products = ref([]);
const searchQuery = ref('');
const selectedCategory = ref('');
const currentPage = ref(1);
const perPage = ref(6);
const likes = ref({});

// Added reactive variables for comments
const comments = ref({});
const visibleComments = ref({});
const newCommentText = ref({});

onMounted(() => {
  products.value = productsData.map((prod, index) => ({
    id: prod.id || index,
    title: prod.name,
    ...prod,
  }));

  // Initialize comments related reactive objects
  products.value.forEach(p => {
    comments.value[p.id] = [];
    visibleComments.value[p.id] = false;
    newCommentText.value[p.id] = '';
  });
});

const filteredProducts = computed(() => {
  return products.value.filter(product => {
    const searchLower = searchQuery.value.toLowerCase();
    const matchesSearch =
      product.title.toLowerCase().includes(searchLower) ||
      product.description.toLowerCase().includes(searchLower);
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

// FIXED: likeProduct accepts productId (not product)
function likeProduct(productId) {
  if (!loggedInUser.value) {
    alert('Please log in to like products.');
    return;
  }
  likes.value[productId] = (likes.value[productId] || 0) + 1;
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

// Toggle comments visibility
function toggleCommentBox(productId) {
  visibleComments.value[productId] = !visibleComments.value[productId];
}

// Add new comment
function addComment(productId) {
  if (!loggedInUser.value) {
    alert('Please log in to add comments.');
    return;
  }
  const commentText = newCommentText.value[productId]?.trim();
  if (!commentText) return;

  const newComment = {
    id: Date.now(), // simple unique id
    user_id: loggedInUser.value.user_id,
    username: loggedInUser.value.username,
    comment: commentText,
    created_at: new Date().toLocaleString(),
  };

  comments.value[productId].push(newComment);
  newCommentText.value[productId] = '';
}

// Delete a comment
function deleteComment(commentId, productId) {
  if (!loggedInUser.value) {
    alert('Please log in to delete comments.');
    return;
  }
  const commentIndex = comments.value[productId].findIndex(c => c.id === commentId);
  if (commentIndex !== -1) {
    if (comments.value[productId][commentIndex].user_id === loggedInUser.value.user_id) {
      comments.value[productId].splice(commentIndex, 1);
    } else {
      alert('You can only delete your own comments.');
    }
  }
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
