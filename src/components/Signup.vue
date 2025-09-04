<script setup>
import { ref, watch } from 'vue'
import { useRouter } from 'vue-router'

const firstName = ref('')
const lastName = ref('')
const email = ref('')
const password = ref('')
const confirmPassword = ref('')
const username = ref('')

const error = ref('')
const success = ref('')
const errors = ref({})

const router = useRouter()


// Validate password & confirm password
watch(password, (newVal) => {
  const pattern = /(?=.*[\$\%\^\&\*]).{6,}/
  if (!pattern.test(newVal)) {
    errors.value.password = 'Min 6 chars incl. special char ($, %, ^, &, *)'
  } else {
    delete errors.value.password
  }

  if (confirmPassword.value && newVal !== confirmPassword.value) {
    errors.value.confirmPassword = 'Passwords do not match.'
  } else {
    delete errors.value.confirmPassword
  }
})

watch(confirmPassword, (newVal) => {
  if (newVal !== password.value) {
    errors.value.confirmPassword = 'Passwords do not match.'
  } else {
    delete errors.value.confirmPassword
  }
})

// Validate username length
watch(username, (newVal) => {
  if (newVal.length < 3) {
    errors.value.username = 'Username must be at least 3 characters.'
  } else {
    delete errors.value.username
  }
})

// Validate email format
watch(email, (newVal) => {
  const pattern = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/
  if (!pattern.test(newVal)) {
    errors.value.email = 'Invalid email format.'
  } else {
    delete errors.value.email
  }
})

// Signup function
async function handleSignup() {
  error.value = ''
  success.value = ''

  if (Object.keys(errors.value).length > 0) {
    error.value = 'Please fix the errors above.'
    return
  }

  console.log({
    first_name: firstName.value,
    last_name: lastName.value,
    email: email.value,
    password: password.value,
    username: username.value
  })

  try {
    const response = await fetch(proxyURL(targetBaseURL), {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        first_name: firstName.value,
        last_name: lastName.value,
        email: email.value,
        password: password.value,
        username: username.value
      })
    })

    if (!response.ok) throw new Error('Failed to connect to server.')

    const result = await response.json()

    if (result.error) {
      error.value = result.error
    } else if (result.success) {
      success.value = 'Sign up successfully...'
      // Clear fields
      firstName.value = ''
      lastName.value = ''
      email.value = ''
      password.value = ''
      confirmPassword.value = ''
      username.value = ''

      setTimeout(() => {
        router.push('/login')
      }, 2000)
    }
  } catch (err) {
    error.value = 'Something went wrong. Try again later.'
  }
}
</script>
