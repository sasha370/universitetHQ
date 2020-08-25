//Black list all the attachments
// window.addEventListener("trix-file-accept", function (even) {
//     event.preventDefault()
//     alert("File attachment not supported!")
// })


// White list for Images

window.addEventListener("trix-file-accept", function (event) {
    const acceptedTypes = ['image/jpeg', 'image/png', 'video/mp4']
    if (!acceptedTypes.includes(event.file.type)) {
        event.preventDefault()
        alert("You can attached only Images(jpeg/png)")
    }
})
//
// // Check File size
//
// window.addEventListener("trix-file-accept", function (event) {
//     const maxFileSize = 1024*1024 // 1 MB
//     if (event.file.size > maxFileSize) {
//         event.preventDefault()
//         alert("You can attached file less than 50 MB")
//     }
// })