var hideElements = document.getElementsByClassName('hidden')

document.getElementById('show-btn').addEventListener('click', function (e) {
  e.preventDefault()
  hideElements.forEach(function (element) {
    element.classList.remove('hidden')
  })
})
