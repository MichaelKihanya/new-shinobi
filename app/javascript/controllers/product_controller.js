import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["mainImage", "thumbnailBtn", "sizeBtn", "form"]
  static values = {
    stripeKey: String,
    checkoutUrl: String
  }

  connect() {
    // Initialize Stripe
    this.stripe = Stripe(this.stripeKeyValue)
    
    // Set initial active states
    if (this.thumbnailBtnTargets.length > 0) {
      this.thumbnailBtnTargets[0].classList.add('active')
    }
  }

  updateImage(event) {
    event.preventDefault()
    
    // Get the clicked thumbnail's image
    const thumbnailBtn = event.currentTarget
    const thumbnailImg = thumbnailBtn.querySelector('img')
    
    // Update main image
    this.mainImageTarget.src = thumbnailImg.src
    this.mainImageTarget.alt = thumbnailImg.alt
    
    // Update active state
    this.thumbnailBtnTargets.forEach(btn => btn.classList.remove('active'))
    thumbnailBtn.classList.add('active')
  }

  selectSize(event) {
    event.preventDefault()
    
    // Update active state
    this.sizeBtnTargets.forEach(btn => btn.classList.remove('active'))
    event.currentTarget.classList.add('active')
  }

  async checkout(event) {
    event.preventDefault()
    
    // Get selected size and quantity
    const selectedSize = this.sizeBtnTargets.find(btn => btn.classList.contains('active'))?.textContent.trim()
    const quantity = this.formTarget.querySelector('[name="quantity"]').value
    
    if (!selectedSize) {
      alert('Please select a size')
      return
    }
    
    try {
      // Create checkout session
      const response = await fetch(this.checkoutUrlValue, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content
        },
        body: JSON.stringify({
          size: selectedSize,
          quantity: quantity
        })
      })
      
      const { sessionId } = await response.json()
      
      // Redirect to Stripe checkout
      const { error } = await this.stripe.redirectToCheckout({
        sessionId: sessionId
      })
      
      if (error) {
        console.error('Error:', error)
        alert('Something went wrong. Please try again.')
      }
    } catch (error) {
      console.error('Error:', error)
      alert('Something went wrong. Please try again.')
    }
  }
} 