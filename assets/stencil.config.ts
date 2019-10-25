import { Config } from '@stencil/core';
import { sass } from '@stencil/sass'

export const config: Config = {
  plugins: [sass()],
  namespace: 'assets',
  outputTargets: [
    {
      type: 'dist',
      esmLoaderPath: '../loader',
      dir: '../priv/static/dist'
    },
    {
      type: 'docs-readme'
    },
    {
      type: 'www',
      dir: '../priv/static/js',
      serviceWorker: null // disable service workers
    }
  ]
};
