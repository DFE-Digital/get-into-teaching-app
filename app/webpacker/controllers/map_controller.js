/* eslint-disable no-undef */
import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ['container'];
  map = null;

  connect() {
    this.initMap();
  }

  initMap() {
    if (!global.mapsLoaded || this.map) return;

    const geocoder = new google.maps.Geocoder();
    geocoder.geocode(
      { address: this.data.get('destination') },
      (results, status) => {
        if (status === 'OK') {
          this.drawMap(results[0].geometry.location);
        }
      },
    );
  }

  drawMap(latLng) {
    const $map = this.containerTarget;

    const Popup = this.createPopupClass();

    const map = new google.maps.Map($map, {
      mapTypeId: google.maps.MapTypeId.ROADMAP,
      mapTypeControl: false,
      scaleControl: false,
      streetViewControl: false,
      rotateControl: false,
      fullscreenControl: true,
      fullscreenControlOptions: {
        position: google.maps.ControlPosition.RIGHT_BOTTOM,
      },
      zoom: 17,
      center: latLng,
      styles: [
        {
          featureType: 'poi.business',
          stylers: [
            {
              visibility: 'off',
            },
          ],
        },
        {
          featureType: 'poi.park',
          elementType: 'labels.text',
          stylers: [
            {
              visibility: 'off',
            },
          ],
        },
      ],
    });

    const closedContent = document.createElement('div');
    closedContent.innerHTML = this.data.get('title');

    const openContent = document.createElement('div');
    openContent.insertAdjacentHTML(
      'beforeend',
      `<p class="govuk-body">${this.data.get('description')}</p>`,
    );

    const popup = new Popup(latLng, closedContent, openContent);
    popup.setMap(map);
  }

  // Based on: https://developers.google.com/maps/documentation/javascript/examples/overlay-popup

  createPopupClass() {
    const panToWithOffset = function (map, latlng, offsetX, offsetY) {
      const ov = new google.maps.OverlayView();
      ov.onAdd = function () {
        const proj = this.getProjection();
        const aPoint = proj.fromLatLngToContainerPixel(latlng);
        aPoint.x = aPoint.x + offsetX;
        aPoint.y = aPoint.y + offsetY;
        map.panTo(proj.fromContainerPixelToLatLng(aPoint));
      };
      ov.draw = function () {};
      ov.setMap(map);
    };

    const Popup = function (position, closedContent, openContent) {
      this.position = position;
      const content = document.createElement('div');
      content.classList.add('map-marker__content');
      content.insertAdjacentHTML(
        'beforeend',
        '<button class="map-marker__close">&times;<span class="govuk-visually-hidden">Close this popup</span></button>',
      );
      closedContent.classList.add('map-marker__title');
      openContent.classList.add('map-marker__body');
      content.appendChild(closedContent);
      content.appendChild(openContent);

      this.anchor = document.createElement('div');
      this.anchor.classList.add('map-marker');
      this.anchor.appendChild(content);

      this.stopEventPropagation();

      const $closeButton = content.querySelector('.map-marker__close');
      $closeButton.addEventListener('click', (e) => {
        this.closeOpenPopups();
      });

      closedContent.addEventListener('click', (e) => {
        panToWithOffset(this.getMap(), this.position, 0, -70);
        this.closeOpenPopups();
        this.anchor.classList.toggle('open');
        e.stopPropagation();
      });
    };

    // NOTE: google.maps.OverlayView is only defined once the Maps API has
    // loaded. That is why Popup is defined inside createPopupClass().
    Popup.prototype = Object.create(google.maps.OverlayView.prototype);

    // Called when the popup is added to the map.
    Popup.prototype.onAdd = function () {
      this.getPanes().floatPane.appendChild(this.anchor);
    };

    // Called when the popup is removed from the map.
    Popup.prototype.onRemove = function () {
      if (this.anchor.parentElement) {
        this.anchor.parentElement.removeChild(this.anchor);
      }
    };

    // Called when the popup needs to draw itself.
    Popup.prototype.draw = function () {
      const divPosition = this.getProjection().fromLatLngToDivPixel(
        this.position,
      );
      // Hide the popup when it is far out of view.
      const display =
        Math.abs(divPosition.x) < 4000 && Math.abs(divPosition.y) < 4000
          ? 'block'
          : 'none';

      if (display === 'block') {
        this.anchor.style.left = divPosition.x + 'px';
        this.anchor.style.top = divPosition.y + 'px';
      }
      if (this.anchor.style.display !== display) {
        this.anchor.style.display = display;
      }
    };

    Popup.prototype.closeOpenPopups = () => {
      const $anchors = document.querySelectorAll('.map-marker.open');
      for (let i = 0; i < $anchors.length; i++) {
        $anchors[i].classList.remove('open');
      }
    };

    // Stops clicks/drags from bubbling up to the map.
    Popup.prototype.stopEventPropagation = function () {
      const anchor = this.anchor;
      anchor.style.cursor = 'auto';
      [
        'click',
        'dblclick',
        'contextmenu',
        'wheel',
        'mousedown',
        'touchstart',
        'pointerdown',
      ].forEach(function (event) {
        anchor.addEventListener(event, function (e) {
          e.stopPropagation();
        });
      });
    };

    return Popup;
  }
}
