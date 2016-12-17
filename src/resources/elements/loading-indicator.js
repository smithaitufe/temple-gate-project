import { bindable, noView } from 'aurelia-framework';
import NProgress from 'nprogress';
import '../../../node_modules/nprogress/nprogress.css';

@noView()
export class LoadingIndicator {
  @bindable busy = false;
  
  busyChanged(newValue){    
    if(newValue) {      
      NProgress.start();
    }
    else {
      NProgress.done();
    }
  }
}
