window.addEventListener("trix-file-accept", function (event) {
    const acceptedTypes = ['image/jpeg', 'image/png', 'video/mp4']
    if (!acceptedTypes.includes(event.file.type)) {
        event.preventDefault()
        alert("You can attached only Images(jpeg/png)")
    }
})
