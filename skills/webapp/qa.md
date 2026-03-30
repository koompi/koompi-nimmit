# QA Procedure

Screenshot, test, and verify before shipping to the user.

## Screenshot

### Desktop
```typescript
// Use Playwright via exec
bunx playwright screenshot --browser chromium \
  --viewport-size "1440,900" \
  --full-page \
  "https://<preview-url>" \
  /tmp/screenshot-desktop.png
```

### Mobile
```typescript
bunx playwright screenshot --browser chromium \
  --viewport-size "390,844" \
  --full-page \
  "https://<preview-url>" \
  /tmp/screenshot-mobile.png
```

### Send to user
Send both screenshots with:
- Preview URL
- "Here's the build. What do you think?"

## Test Checklist

Run these before sending to user:

### Visual
- [ ] Page renders without blank sections
- [ ] Images load (or placeholders shown)
- [ ] Typography is readable (proper sizes, contrast)
- [ ] Mobile layout doesn't overflow
- [ ] Colors match the user's request

### Functional
- [ ] Navigation works (all links resolve)
- [ ] Forms submit without errors
- [ ] Data loads from Supabase
- [ ] Auth pages load (login/signup)

### Technical
- [ ] No console errors (check Playwright logs)
- [ ] Lighthouse performance > 70 (optional, for production)
- [ ] Build succeeded (`bun run build`)

## Common Issues

| Issue | Fix |
|-------|-----|
| Blank page | Check Supabase URL/key in .env, check build logs |
| CSS not loading | Verify Tailwind config, check `@tailwind` directives |
| Font missing | Verify NotoSansKhmer is loaded in layout.tsx |
| Images broken | Check if using placeholder URLs, use picsum for testing |
| Mobile overflow | Add `overflow-x-hidden` to body, check fixed-width elements |
| Supabase connection error | Verify RLS policies, check anon key permissions |

## Sign-off

Only send to user when ALL of these pass:
1. Build succeeds (`bun run build`)
2. Desktop screenshot shows complete page
3. Mobile screenshot shows responsive layout
4. No console errors on core pages
5. Navigation links work
