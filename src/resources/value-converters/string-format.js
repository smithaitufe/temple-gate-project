export class StringFormatValueConverter {
  toView(value, caseType) {
    if (value === null || value === undefined) {
      return null;
    }
    switch(caseType){
      case 'upper':
        return value.toUpperCase();
        break;
      case 'lower':
        return value.toLowerCase();
        break;
      default:
        throw new Error("Invalid case type specified!")

    }
  }

}
