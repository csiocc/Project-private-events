// Zentrale Einstiegspunkt für alle JS-Funktionen

import "@hotwired/turbo-rails"
import * as ActiveStorage from "@rails/activestorage"
window.ActiveStorage = ActiveStorage
ActiveStorage.start()

import { application } from "controllers/application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
eagerLoadControllersFrom("controllers", application)

import "flowbite"

// Debug: check global ActiveStorage
console.log("ActiveStorage globally available:", typeof window.ActiveStorage)