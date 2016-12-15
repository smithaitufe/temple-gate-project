// export class FilterValueConverter {
//   toView(array, searchTerm, filterFunc) {
//     return array.filter((item) => {
//
// 	     let matches = searchTerm && searchTerm.length > 0 ? filterFunc(searchTerm,item): true;
// 	     return matches;
//     });
//   }
// }

export class FilterValueConverter {

  toView(array, searchTerm, filterFunc) {

    return array.filter((item) => {
      this.flattenArray(item);

	     let matches = searchTerm && searchTerm.length > 0 ? filterFunc(item,searchTerm): true;
	     return matches;
    });
  }

  flattenArray(array){
    let flatArray = [];
    console.log(flatArray);
    for (var key in array){
          if(Array.isArray(array)){
            this.flattenArray(key)
          }else{
            this.flatArray.push(item[key])
          }
    }

  }
}


// export class FilterOnPropertyValueConverter {
//   toView(array: {}[], property: string, exp: string) {
//
//       if (array === undefined || array === null || property === undefined || exp === undefined) {
//           return array;
//       }
//       return array.filter((item) => item[property].toLowerCase().indexOf(exp.toLowerCase()) > -1);
//   }
// }
//
// export class HasPropertyValueValueConverter {
//   toView(array: {}[], property: string, exp: string) {
//
//       if (array === undefined || array === null || property === undefined || exp === undefined) {
//           return false;
//       }
//       return array.filter((item) => item[property].toLowerCase().indexOf(exp.toLowerCase()) > -1).length > 0;
//   }
// }
