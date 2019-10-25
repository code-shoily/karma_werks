import { Component, h } from '@stencil/core';

@Component({
  tag: 'kw-welcome',
})
export class KwWelcome {
  render() {
    return (
      <p>
        Welcome to KarmaWerks<sup>TM</sup>
      </p>
    );
  }
}
