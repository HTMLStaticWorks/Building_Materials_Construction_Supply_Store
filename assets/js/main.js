document.addEventListener('DOMContentLoaded', () => {
  initTheme();
  initRTL();
  initCart();
  initMobileMenu();
  initEstimator();
});

// Theme System (Light/Dark)
function initTheme() {
  const themeToggles = document.querySelectorAll('#theme-toggle, #theme-toggle-mobile');
  const body = document.body;
  const icons = document.querySelectorAll('#theme-icon, #theme-icon-mobile');
  
  let currentTheme = localStorage.getItem('theme') || 'light';
  applyTheme(currentTheme);
  
  themeToggles.forEach(toggle => {
    if (toggle) {
      toggle.addEventListener('click', () => {
        currentTheme = currentTheme === 'light' ? 'dark' : 'light';
        applyTheme(currentTheme);
        localStorage.setItem('theme', currentTheme);
      });
    }
  });
  
  function applyTheme(theme) {
    if (theme === 'dark') {
      body.setAttribute('data-theme', 'dark');
      icons.forEach(icon => { if (icon) icon.innerHTML = '<i data-lucide="sun"></i>'; });
    } else {
      body.removeAttribute('data-theme');
      icons.forEach(icon => { if (icon) icon.innerHTML = '<i data-lucide="moon"></i>'; });
    }
    // Re-render lucide icons if using lucide library
    if(typeof lucide !== 'undefined') lucide.createIcons();
  }
}

// RTL/LTR System
function initRTL() {
  const dirToggle = document.getElementById('dir-toggle');
  const html = document.documentElement;
  
  let currentDir = localStorage.getItem('dir') || 'ltr';
  applyDir(currentDir);
  
  if (dirToggle) {
    dirToggle.addEventListener('click', () => {
      currentDir = currentDir === 'ltr' ? 'rtl' : 'ltr';
      applyDir(currentDir);
      localStorage.setItem('dir', currentDir);
    });
  }
  
  function applyDir(dir) {
    html.setAttribute('dir', dir);
    if(dir === 'rtl') {
       // if using Bootstrap RTL CSS you'd load it here dynamically, 
       // but we handle basic RTL via CSS rules and dir="rtl"
    }
  }
}

// Cart System (Dummy Implementation)
function initCart() {
  const cartBadges = document.querySelectorAll('.cart-badge');
  const addToCartBtns = document.querySelectorAll('.add-to-cart-btn');
  
  let cart = JSON.parse(localStorage.getItem('cart')) || [];
  updateCartBadge();
  
  addToCartBtns.forEach(btn => {
    btn.addEventListener('click', (e) => {
      e.preventDefault();
      // Dummy product
      const product = { id: Date.now(), name: "Material", price: 99 };
      cart.push(product);
      localStorage.setItem('cart', JSON.stringify(cart));
      updateCartBadge();
      showToast('Product added to cart!');
    });
  });
  
  function updateCartBadge() {
    cartBadges.forEach(badge => {
      badge.textContent = cart.length;
    });
  }
}

// Mobile Menu Offcanvas
function initMobileMenu() {
  // Assuming Bootstrap's offcanvas handles the bulk, 
  // we just need to ensure links close the menu
  const offcanvasLinks = document.querySelectorAll('.offcanvas .nav-link');
  offcanvasLinks.forEach(link => {
    link.addEventListener('click', () => {
      const offcanvasEl = document.getElementById('mobileMenu');
      if(offcanvasEl && typeof bootstrap !== 'undefined') {
        const bsOffcanvas = bootstrap.Offcanvas.getInstance(offcanvasEl);
        if(bsOffcanvas) bsOffcanvas.hide();
      }
    });
  });
}

// Project Quantity Estimator
function initEstimator() {
  const estForm = document.getElementById('estimator-form');
  if(!estForm) return;
  
  const areaInput = document.getElementById('est-area');
  const depthInput = document.getElementById('est-depth');
  const resultDiv = document.getElementById('est-result');
  
  if(areaInput && depthInput && resultDiv) {
    const calculate = () => {
      const area = parseFloat(areaInput.value) || 0;
      const depth = parseFloat(depthInput.value) || 0;
      const vol = area * depth;
      
      if(vol > 0) {
        resultDiv.innerHTML = `
          <div class="alert alert-success mt-3">
            <strong>Estimated Volume:</strong> ${vol.toFixed(2)} cubic units
            <br>
            <small>Suggested purchase includes 5% waste allowance: ${(vol * 1.05).toFixed(2)} cubic units.</small>
          </div>
        `;
      } else {
        resultDiv.innerHTML = '';
      }
    };
    
    areaInput.addEventListener('input', calculate);
    depthInput.addEventListener('input', calculate);
  }
}

// Toast Notification Utility
function showToast(message) {
  // Simple toast implementation
  const toastContainer = document.getElementById('toast-container') || createToastContainer();
  const toast = document.createElement('div');
  toast.className = 'toast show align-items-center text-bg-success border-0 mb-2';
  toast.setAttribute('role', 'alert');
  toast.setAttribute('aria-live', 'assertive');
  toast.setAttribute('aria-atomic', 'true');
  toast.innerHTML = `
    <div class="d-flex">
      <div class="toast-body">
        ${message}
      </div>
      <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
    </div>
  `;
  
  toastContainer.appendChild(toast);
  
  setTimeout(() => {
    toast.classList.remove('show');
    setTimeout(() => toast.remove(), 300);
  }, 3000);
}

function createToastContainer() {
  const container = document.createElement('div');
  container.id = 'toast-container';
  container.className = 'toast-container position-fixed bottom-0 end-0 p-3';
  container.style.zIndex = '1055';
  document.body.appendChild(container);
  return container;
}
