import { Component, h, Host } from '@stencil/core';

@Component({
  tag: 'kw-welcome',
  shadow: true,
  styleUrl: 'welcome.scss'
})
export class Welcome {
  render() {
    return (
      <Host>
        <h1>Welcome to KarmaWerks</h1>
      </Host>
    );
  }
}
