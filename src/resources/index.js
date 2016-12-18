export function configure(aurelia) {
  aurelia.globalResources(
      './value-converters/date-format',
      './value-converters/number-format',
      './value-converters/currency-format',
      './value-converters/string-format',
      './value-converters/stringify',
      './value-converters/sort',
      './value-converters/take',
      './attributes/active-link',
      './attributes/markdown-component',
      './attributes/datepicker',
      './elements/markdown',      
      './elements/loading-indicator'
    );
}
