# Git Workflow

Bu repository uchun default branch `dev`. Kod faqat pull request orqali
protected branchlarga kiradi.

## Branchlar

- `dev`: kundalik development va feature PRlar uchun default branch.
- `prod`: release candidate va production deployga tayyor holat.
- `main`: production snapshot va barqaror tarix.
- `feature/*`, `fix/*`, `chore/*`: ishchi branchlar.

## Merge Yo'nalishi

- Feature branchlar faqat `dev`ga PR qilinadi.
- Release promotion faqat `dev`dan `prod`ga PR orqali qilinadi.
- Production snapshot faqat `prod`dan `main`ga PR orqali qilinadi.
- `dev`, `prod`, `main`ga direct push qilinmaydi.

## PR Talablari

Har bir PR quyidagi quality gatedan o'tishi kerak:

- `flutter analyze`
- `dart format --set-exit-if-changed .`
- `flutter test`
- `promotion-guard`

PR merge bo'lishidan oldin:

- kamida 1 approval bo'lishi kerak;
- stale approval yangi commitdan keyin bekor qilinadi;
- barcha review conversationlar resolve qilinadi;
- required checks pass bo'ladi;
- branch base bilan up to date bo'ladi.

## Merge Huquqi

Protected branchlarga merge/push huquqi faqat `Nomonjon0124` accountiga
beriladi. Boshqa contributorlar branch ochishi va PR yuborishi mumkin, lekin
`dev`, `prod`, `main` branchlariga kodni birlashtira olmaydi.

## Repo Sozlamalari

- Squash merge yoqilgan.
- Merge commit o'chirilgan.
- Rebase merge o'chirilgan.
- Auto-merge o'chirilgan.
- PR merge qilingandan keyin source branch avtomatik o'chiriladi.
- Protected branch deletion va force push o'chirilgan.

## Release Tartibi

1. Feature/fix PR `dev`ga merge qilinadi.
2. Release tayyor bo'lganda `dev -> prod` PR ochiladi.
3. Productionga chiqadigan commit tasdiqlanganda `prod -> main` PR ochiladi.
4. `prod` va `main` branchlar faqat promotion PR orqali yangilanadi.
