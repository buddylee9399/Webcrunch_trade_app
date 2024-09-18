# Episode 27 Presentations with PPtxGenJs

- https://www.youtube.com/watch?v=ypKeMRCLO2A
- https://gitbrent.github.io/PptxGenJS/
- ./bin/importmap pin pptxgenjs
- update hello controller.js

```
import { Controller } from "@hotwired/stimulus"
import { jsPDF } from "jspdf";
import pptxgen from 'pptxgenjs';
export default class extends Controller {

  generatePPTX(){
    // 2. Add a Slide
    let slide = this.pres.addSlide();

    // 3. Add one or more objects (Tables, Shapes, Images, Text and Media) to the Slide
    // let textboxText = "Hello World from PptxGenJS!";
    // let textboxOpts = { x: 1, y: 1, color: "363636" };

   // console.log(' im in generatePPTX'); 
    const data = document.getElementById('users');
    // console.log(data);
    slide.addText(data.innerHTML);
    // 4. Save the Presentation
    this.pres.writeFile();         
  }

  generatePDF(){
    // this.doc.save("a4.pdf");   
    // console.log(' im in generatePDF');
    const data = document.getElementById('users');
    // console.log(data);
    this.doc.html(data.innerHTML).save('test.pdf');

  }

  connect() {
    // this.element.textContent = "Hello World!"
    // console.log('im in connect');

    // Default export is a4 paper, portrait, using millimeters for units
    this.doc = new jsPDF();
    // this.doc.text("This is it", 10, 10);
     
    // 1. Create a new Presentation
    this.pres = new pptxgen();



    
  }
}

```

- update users index

```
<div id="users" data-controller='hello'>
<button data-action="click->hello#generatePDF">Generate PDF</button>
<button data-action="click->hello#generatePPTX">Generate PowerPoint</button>
```