<template>
  <div class="container-fluid vh-100 d-flex align-items-center justify-content-center bg-light">
    <div class="row w-100 shadow rounded overflow-hidden" style="max-width: 900px; min-height: 500px;">
      <!-- Left side image -->
      <div class="col-md-6 d-none d-md-block p-0">
        <img
          src="/image/shopping3.jpg"
          alt="Login visual"
          class="img-fluid h-100 w-100 object-fit-cover"
          style="object-fit: cover;"
        />
      </div>

      <!-- Right side form -->
      <div class="col-md-6 bg-white d-flex flex-column justify-content-center align-items-center p-5">
        <h2 class="mb-4 text-center text-dark">Log In</h2>
        <form class="w-100" style="max-width: 350px;" @submit.prevent="handleLogin">
          <div class="mb-3">
            <label class="form-label fw-bold">Username</label>
            <input v-model="username" type="text" class="form-control" required />
          </div>
          <div class="mb-4">
            <label class="form-label fw-bold">Password</label>
            <input v-model="password" type="password" class="form-control" required />
          </div>
          <button type="submit" class="btn btn-primary w-100" style="background-color: #e83e8c;">Login</button>
        </form>

        <!-- Link to Signup Page -->
        <p class="mt-3 text-center">
          Don't have an account?
          <router-link to="/signup" class="text-decoration-none" style="color: #e83e8c;">Sign up here</router-link>
        </p>

        <!-- Error or Success Message -->
        <div v-if="error" class="alert alert-danger mt-3 w-100 text-center">{{ error }}</div>
        <div v-if="success" class="alert alert-success mt-3 w-100 text-center">{{ success }}</div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue';
import { useRouter } from 'vue-router';

const router = useRouter();
const username = ref('');
const password = ref('');
const error = ref('');
const success = ref('');
const loggedInUser = ref(null);

const proxyBase = "https://cors-proxy-production-99.up.railway.app";
const targetURL = "https://myproject1.infinityfreeapp.com/resource/api_user.php";

async function handleLogin() {
  error.value = '';
  success.value = '';

  try {
    const response = await fetch(`${proxyBase}?url=${encodeURIComponent(targetURL)}`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        username: username.value,
        password: password.value,
      }),
    });

    const result = await response.json();

    if (result.error) {
      error.value = result.error;
    } else if (result.success) {
      success.value = result.message || 'Login successful!';
      loggedInUser.value = { username: username.value };
      router.push('/');
    } else {
      error.value = 'Unexpected response from server.';
    }
  } catch (err) {
    console.error('Login error:', err);
    error.value = 'Could not connect to server. Please try again later.';
  }
}
</script>
