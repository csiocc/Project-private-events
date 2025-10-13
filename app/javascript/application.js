// app/javascript/application.js

import "@hotwired/turbo-rails"
import * as ActiveStorage from "@rails/activestorage"
window.ActiveStorage = ActiveStorage
ActiveStorage.start()

import { application } from "controllers/application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
eagerLoadControllersFrom("controllers", application)

import "flowbite"

// debug check
console.log("ActiveStorage globally available:", typeof window.ActiveStorage)