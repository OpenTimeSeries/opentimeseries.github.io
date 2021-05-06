function changeImgToA() {
    let imgs = document.getElementsByTagName("img");
    for (let i = imgs.length - 1; i >= 0; i--) {
        let img = imgs[i];
        let a = document.createElement("a");
        a.href = img.src;
        a.setAttribute("data-lightbox", img.alt.replace(/\s+/g, '-').toLowerCase());
        let p = img.parentElement;
        p.removeChild(img);
        a.appendChild(img);
        p.appendChild(a);
    }
}