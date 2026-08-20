# btgestor-frontend

App iOS (SwiftUI) do **gestor de arena**: painel de reservas, cadastro de arenas e quadras.

## Setup

```bash
# clone bt-shared ao lado deste repo (../bt-shared)
brew install xcodegen
xcodegen generate
open BTGestor.xcodeproj
```

Backend local: `swift run App serve` em `bt-backend`. A URL vem de `BTGestor/Config/Debug.xcconfig` (`API_BASE_URL`). Login de teste: `gestor@bt.dev` / `123456`.

Toda comunicação com a API passa pelo `APIClient` do pacote `bt-shared` — não crie chamadas HTTP aqui.
