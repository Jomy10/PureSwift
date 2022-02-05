/**
 * This will add an elipsis to text inside of `index.leaf` 
 * if a card overflows.
 * */
const elipsis = () => {
    const packages = document.querySelectorAll('.package');
    Array.prototype.forEach.call(packages, (package) => {
      let content = package.querySelector('.content');
      let p = content.querySelector('.content-text');
      let text = content.querySelector('.saved-text')
      let h3 = content.querySelector('h3');
      let categories = content.querySelector('.categories');
      let packageH = package.clientHeight;
      // Reset p's content
      p.textContent = text.textContent;
      const padding = 15;
      let categories_margin = 10;
      let height = packageH - h3.clientHeight - padding * 4 - categories_margin * 2 - categories.clientHeight;
      while (p.offsetHeight > height) {
        p.textContent = p.textContent.replace(/\W*\s(\S)*$/, '...');
      }
    });
}