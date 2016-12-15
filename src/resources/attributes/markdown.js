import { customAttribute, inject, bindingMode } from 'aurelia-framework';
import showdown from 'showdown';
@customAttribute('markdown', bindingMode.twoWay)
@inject(Element)
export class Markdown {
    constructor(element) {
        this.element = element;
    }
    bind(){
        console.log(this.value);
    }
    attached(){
        console.log(this.value);
    }
    valueChanged(newValue) {
        if (newValue) {
            console.log(newValue);
            let converter = new showdown.Converter();
            this.element.innerHTML = converter.makeHTML(newValue.value.split('\n').map(line => line.trim()).join('\n'));
        }
    }

}