import { Application } from 'stimulus';
import TableController from 'table_controller.js';

describe('TableController', () => {

  beforeAll(() => registerController());

  const setBody = () => {
    document.body.innerHTML = `
      <div data-controller="table">
        <div class="markdown">
          <table>
            <thead>
              <tr>
                <th class="empty-col"><!-- empty --></th>
                <th class="col">Col 1</th>
                <th class="col">Col 2</th>
                <th class="col-with-scope" scope="row">Col 3</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>Cell 1</td>
                <td>Cell 2</td>
                <td>Cell 3</td>
                <td>Cell 4</td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    `;
  }

  const registerController = () => {
    const application = Application.start();
    application.register('table', TableController);
  }

  beforeEach(() => {
    setBody();
  });

  it('adds a col scope to headings', () => {
    const cols = document.querySelectorAll('.col');
    cols.forEach(col => expect(col.scope).toEqual('col'))
  })

  it('does not add a scope to empty headings', () => {
    const emptyCol = document.querySelector('.empty-col')
    expect(emptyCol.scope).toBe("");
  })

  it('does not change an existing scope', () => {
    const colWithScope = document.querySelector('.col-with-scope')
    expect(colWithScope.scope).toEqual('row');
  })
});
