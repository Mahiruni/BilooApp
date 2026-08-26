const systemTheme = window.matchMedia('(prefers-color-scheme: dark)');

function syncSystemTheme() {
  const dark = systemTheme.matches;
  const root = document.documentElement;

  // Biloo follows the operating-system appearance. Never retain a manual override.
  root.removeAttribute('data-force-theme');
  root.style.colorScheme = dark ? 'dark' : 'light';
  root.dataset.systemTheme = dark ? 'dark' : 'light';

  // Keep mobile browser chrome aligned with the app canvas.
  document.querySelector('meta[name="theme-color"]')?.setAttribute(
    'content',
    dark ? '#000000' : '#F8F7F4',
  );

  // The profile control is informational now; appearance is owned by the device.
  document.querySelectorAll('[data-theme]').forEach((button) => {
    button.textContent = `Appearance · System (${dark ? 'Dark' : 'Light'})`;
    button.setAttribute('aria-label', `Appearance follows device setting. Current appearance: ${dark ? 'dark' : 'light'}`);
  });
}

syncSystemTheme();

if (systemTheme.addEventListener) {
  systemTheme.addEventListener('change', syncSystemTheme);
} else {
  systemTheme.addListener(syncSystemTheme);
}

// app.js re-renders sections of the page. Refresh the informational appearance label after each render.
const observer = new MutationObserver(() => syncSystemTheme());
observer.observe(document.documentElement, { childList: true, subtree: true });

// Prevent the legacy preview button from overriding the system appearance.
document.addEventListener('click', (event) => {
  const target = event.target.closest?.('[data-theme]');
  if (!target) return;
  event.preventDefault();
  event.stopImmediatePropagation();
  syncSystemTheme();
}, true);
