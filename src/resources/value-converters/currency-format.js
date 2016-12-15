import numeral from 'numeral';

export class CurrencyFormatValueConverter {
  toView(value) {
    return numeral(value).format('(N0,0.00)');
  }
}
