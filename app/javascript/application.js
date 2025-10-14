// Zentrale Einstiegspunkt für alle JS-Funktionen

import "@hotwired/turbo-rails"
import "./controllers"
import * as ActiveStorage from "@rails/activestorage"
window.ActiveStorage = ActiveStorage
ActiveStorage.start()

import { application } from "./controllers/application"
eagerLoadControllersFrom("controllers", application)

import "flowbite"

// Debug: check global ActiveStorage
console.log("ActiveStorage globally available:", typeof window.ActiveStorage)


document.addEventListener("DOMContentLoaded", function() {
  const toggle = document.getElementById('menu-toggle');
  const menu = document.getElementById('mobile-menu');
  if (toggle && menu) {
    toggle.addEventListener('click', function() {
      menu.classList.toggle('hidden');
    });
  }
});