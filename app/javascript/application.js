// app/javascript/application.js
import "@hotwired/turbo-rails"
import * as ActiveStorage from "@rails/activestorage"
ActiveStorage.start()

import "./controllers"     // <- wichtig: relativ, KEIN alias
import "flowbite"

// Falls du DOM-Init brauchst, nimm turbo:load (nicht DOMContentLoaded)
document.addEventListener("turbo:load", () => {
  const toggle = document.getElementById("menu-toggle")
  const menu = document.getElementById("mobile-menu")
  if (toggle && menu) toggle.addEventListener("click", () => menu.classList.toggle("hidden"))
})
