import { Config } from '@stencil/core';

export const config: Config = {
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
