#!/usr/bin/env bash
. "$(dirname "$0")/lib.sh"
mise use -g node@22
mkdir pw && cd pw && npm init -y > /dev/null
npm install --silent -D @playwright/test@1.56
asroot npx playwright install-deps chromium firefox
npx playwright install chromium firefox
mkdir tests
cat > playwright.config.ts <<TS
import { defineConfig, devices } from "@playwright/test";
export default defineConfig({ projects: [
  { name: "chromium", use: { ...devices["Desktop Chrome"] } },
  { name: "firefox", use: { ...devices["Desktop Firefox"] } },
] });
TS
cat > tests/page.spec.ts <<TS
import { test, expect } from "@playwright/test";
test("renders and computes", async ({ page }) => {
  await page.setContent("<button onclick=\"this.textContent=6*7\">go</button>");
  await page.click("button");
  await expect(page.locator("button")).toHaveText("42");
});
TS
npx playwright test
