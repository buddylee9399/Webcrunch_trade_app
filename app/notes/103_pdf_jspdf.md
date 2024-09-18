# Episode 28 Creating PDFs in Rails

- https://www.youtube.com/watch?v=nOJzasU0ypU
- https://github.com/parallax/jsPDF
- ./bin/importmap pin jspdf
- update hello-controller.js

```
import { Controller } from "@hotwired/stimulus"
import { jsPDF } from "jspdf";
export default class extends Controller {

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
     
  }
}

```

- update users/index

```
<div id="users" data-controller='hello'>
<button data-action="click->hello#generatePDF">Generate PDF</button>
  <% @users.each do |user| %>
    <p>
```