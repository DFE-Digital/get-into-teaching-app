import fs from 'fs';
import path from 'path';

describe('controllers/index.js', () => {
  const dir = path.join(__dirname, '../../../app/javascript/controllers');
  const index = fs.readFileSync(path.join(dir, 'index.js'), 'utf8');
  const controllers = fs
    .readdirSync(dir)
    .filter((file) => file.endsWith('_controller.js'));

  it('finds the controllers', () => {
    expect(controllers.length).toBeGreaterThan(0);
  });

  it.each(controllers)('imports and registers %s', (file) => {
    const name = file.replace('_controller.js', '');
    const identifier = name.replace(/_/g, '-');

    expect(index).toContain(`'./${name}_controller'`);
    expect(index).toContain(`application.register('${identifier}'`);
  });
});
