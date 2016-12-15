import {inject, customAttribute} from 'aurelia-framework';
import { AppRouter } from 'aurelia-router';

@inject(Element, AppRouter)
@customAttribute("active-link")
export class ActiveLink{

  constructor(element, router){
    this.router = router;
    this.element = element;
    console.log(this.router);
  }
  attached(){
    let current_url = this.router.history.location.hash;
    // if(this.element.getAttribute("href") === current_url){
    //   this.element.className += " active"
    // }
    let href = $(this.element).find("a").attr("href")
    if(href === current_url){
      $(this.element).siblings().removeClass("active").end().addClass("active")
    }
  }

}
