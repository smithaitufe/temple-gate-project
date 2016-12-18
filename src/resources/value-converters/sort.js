export class SortValueConverter {
  toView(array, config) {
    var factor = config.direction === 'asc' ? 1 : -1;
    config.depth = config.depth || 0;
    switch (config.depth) {
      case 0:
        return array
          .slice(0)
          .sort((a, b) => {
            return (a[config.field] - b[config.field]) * factor
          });
        break;
      case 1:
        return array
          .slice(0)
          .sort((a, b) => {
            return (a[config.obj][config.field] - b[config.obj][config.field]) * factor
          });
        break;
    }

  }
}
