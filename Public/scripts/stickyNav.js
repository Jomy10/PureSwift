window.onscroll = () => { onScroll() };
var navbar = document.getElementById("navbar");
var sticky = navbar.offsetTop - 25;
const onScroll = () => {
    if (window.pageYOffset >= sticky) {
    navbar.classList.add("sticky");
    navbar.classList.remove("index-nav");
    } else {
    navbar.classList.remove("sticky");
    navbar.classList.add("index-nav");
    }
}