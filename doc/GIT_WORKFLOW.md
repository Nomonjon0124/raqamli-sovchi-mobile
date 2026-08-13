# Git Workflow

Bu repository uchun default branch `dev`. Kod faqat pull request orqali
protected branchlarga kiradi.

## Fork Remote Modeli

Lokal loyiha fork orqali ishlaydi:

- `origin`: shaxsiy fork, pushlar shu repoga yuboriladi.
  `https://github.com/Nomonjon0124/raqamli-sovchi-mobile.git`
- `upstream`: asosiy repository, faqat yangilik olish uchun ishlatiladi.
  `https://github.com/raqamli-nazorat/raqamli-sovchi-mobile.git`

Remote sozlash:

```bash
git remote set-url origin https://github.com/Nomonjon0124/raqamli-sovchi-mobile.git
git remote add upstream https://github.com/raqamli-nazorat/raqamli-sovchi-mobile.git
git remote set-url --push upstream DISABLED
git fetch --all --prune
```

Agar `upstream` oldindan mavjud bo'lsa:

```bash
git remote set-url upstream https://github.com/raqamli-nazorat/raqamli-sovchi-mobile.git
git remote set-url --push upstream DISABLED
```

`upstream`ga to'g'ridan-to'g'ri push qilinmaydi. Feature branchlar forkdagi
`origin`ga push qilinadi va PR asosiy repositoryning `dev` branchiga ochiladi.

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
- Agentlar ham shu qoidaga bo'ysunadi: protected branchda lokal commit
  qoldirmaydi, scoped branch ochadi va PR orqali ishlaydi.

## PR Talablari

Har bir PRdan oldin local muhitda quyidagi tekshiruvlar bajariladi:

- `flutter analyze`
- `dart format --set-exit-if-changed .`
- kerakli unit/widget/BLoC testlar

GitHub Actions PR yoki protected branch push paytida avtomatik ishlamaydi.
`.github/workflows/flutter-ci.yml` faqat qo'lda `workflow_dispatch` orqali
ishga tushiriladi. Tekshiruvlar repositoryga push qilishdan oldin lokal
muhitda bajariladi.

PR merge bo'lishidan oldin:

- kamida 1 approval bo'lishi kerak;
- stale approval yangi commitdan keyin bekor qilinadi;
- barcha review conversationlar resolve qilinadi;
- branch base bilan up to date bo'ladi.

## Agent Ish Tartibi

Agent Git bilan ishlashdan oldin `AGENTS.md` va ushbu faylni o'qiydi.

- Remote holatini tekshiradi: `git remote -v`. `origin` forkka, `upstream`
  asosiy repositoryga qarashi kerak.
- Ishni asosiy repositoryning yangilangan `dev` branchidan boshlaydi:
  `git fetch upstream --prune`, keyin lokal `dev`ni `upstream/dev` bilan
  yangilaydi.
- Scoped branch lokal `dev` yoki bevosita `upstream/dev`dan yaratiladi.
- Branch nomi ish turini bildiradi: `feature/*`, `fix/*`, yoki `chore/*`.
- Stage qilishdan oldin `git status --short` va `git diff` bilan faqat kerakli
  fayllar tanlanganini tekshiradi.
- Commit xabari qisqa, aniq va imperative bo'ladi.
- Branch faqat forkdagi `origin`ga push qilinadi:
  `git push -u origin <branch>`.
- Protected branchlarga va `upstream`ga direct push qilmaydi.
- PR head fork branchi bo'ladi, base esa asosiy repositorydagi `dev`.
  Release uchun faqat `dev -> prod`, production snapshot uchun faqat
  `prod -> main`.
- Branch protection, collaborator, default branch yoki merge settings o'zgarishi
  faqat user aniq so'raganda qilinadi.
- User so'ramasa, admin/protection sozlamalari o'zgartirilmaydi.

## Oddiy Ishlash Ketma-ketligi

Yangi ish boshlash:

```bash
git fetch upstream --prune
git switch dev
git merge --ff-only upstream/dev
git push origin dev
git switch -c feature/<task-name>
```

Ishni push qilish:

```bash
git status --short
git diff --check
dart format --set-exit-if-changed .
flutter analyze
git add <changed-files>
git commit -m "<type>: <short description>"
git push -u origin feature/<task-name>
```

PR ochish:

```bash
gh pr create \
  --repo raqamli-nazorat/raqamli-sovchi-mobile \
  --base dev \
  --head Nomonjon0124:feature/<task-name>
```

Issue avtomatik yopilishi kerak bo'lsa PR body ichiga `Closes #<issue-number>`
qo'shiladi.

Asosiy repositorydan oxirgi yangiliklarni olish:

```bash
git fetch upstream --prune
git switch dev
git merge --ff-only upstream/dev
git push origin dev
```

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
