import {inject,bindable,noView,useView,useShadowDOM} from 'aurelia-framework';

import showdown from 'showdown';
import prism from 'prismjs';

@noView
@inject(Element)
export class MarkdownCustomElement {

  constructor(element){
    this.element = element;
    this.converter = new showdown.Converter();
    this.root = element.createShadowRoot();
  }

  attached(){
    this.valueChanged(this.element.innerHTML);    
  }


  valueChanged(newValue){
      console.log(newValue);
    this.root.innerHTML = this.converter.makeHtml(dedent(newValue));
    let codes = this.root.querySelectorAll('pre code');
    for(let node of codes) prism.highlightElement(node);
  }
}



export function dedent(str){
  var match = str.match(/^[ \t]*(?=\S)/gm);
  if (!match) return str;

  var indent = Math.min.apply(Math, match.map(function (el) {
    return el.length;
  }));

  var re = new RegExp('^[ \\t]{' + indent + '}', 'gm');
  return indent > 0 ? str.replace(re, '') : str;
}
