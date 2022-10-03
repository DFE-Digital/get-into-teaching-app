import { Application } from 'stimulus';
import YoutubeVideoController from 'youtube_video_controller.js';

describe('YoutubeVideoController', () => {
  beforeAll(() => registerController());

  const setBody = (preview) => {
    document.body.innerHTML = `
      <div data-controller="youtube-video">
        ${preview}
        <iframe id="video" data-youtube-video-target="video"></iframe>
      </div>
    `;
  }

  const registerController = () => {
    const application = Application.start();
    application.register('youtube-video', YoutubeVideoController);
  }

  describe('when there is no preview image', () => {
    beforeEach(() => {
      setBody();
    });

    it('displays the video', () => {
      expect(document.getElementById("video").classList).not.toContain('hidden');
    });
  })

  describe('when there is a preview image', () => {
    beforeEach(() => {
      const preview = `
        <a
          href="javascript:void(0)"
          id="preview"
          data-youtube-video-target="preview"
          data-action="youtube-video#play"
          class="hidden">
            <img src="a/preview/image.png">
        </a>
      `;
      setBody(preview);
    });

    it('displays the preview image', () => {
      expect(document.getElementById("preview").classList).not.toContain('hidden');
    });

    it('does not display the video', () => {
      expect(document.getElementById("video").classList).toContain('hidden');
    });

    describe('when clicking on the preview image', () => {
      beforeEach(() => {
        document.getElementById("preview").click();
      });

      it('hides the preview image', () => {
        expect(document.getElementById("preview").classList).toContain('hidden');
      });

      it('displays the video', () => {
        expect(document.getElementById("video").classList).not.toContain('hidden');
      });
    });
  })
});
