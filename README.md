# 🔍 SonarQube Demo - Intégration avec GitHub Actions

Ce projet démontre l'intégration de SonarCloud avec GitHub Actions pour l'analyse automatique de la qualité du code d'une application Spring Boot.

## 📋 Table des matières

- [Prérequis](#prérequis)
- [Configuration SonarCloud](#configuration-sonarcloud)
- [Configuration GitHub Secrets](#configuration-github-secrets)
- [Structure du projet](#structure-du-projet)
- [Installation locale](#installation-locale)
- [Comment ça marche](#comment-ça-marche)
- [Visualiser les résultats](#visualiser-les-résultats)

## 🎯 Prérequis

- Java 17 ou supérieur
- Maven 3.6+
- Un compte GitHub
- Un compte SonarCloud (gratuit pour les projets publics)

## ⚙️ Configuration SonarCloud

### Étape 1 : Créer un compte SonarCloud

1. Va sur **https://sonarcloud.io**
2. Clique sur **"Log in"** et choisis **"With GitHub"**
3. Autorise SonarCloud à accéder à ton compte GitHub

### Étape 2 : Créer un projet

1. Une fois connecté, clique sur **"+"** en haut à droite
2. Sélectionne **"Analyze new project"**
3. Choisis ton organisation GitHub
4. Sélectionne le repository `sonarqube-demo` (ou crée-le d'abord)
5. Clique sur **"Set Up"**

### Étape 3 : Configurer le projet

SonarCloud va te demander comment tu veux analyser ton projet :

1. Choisis **"With GitHub Actions"**
2. SonarCloud va te montrer :
   - **SONAR_TOKEN** : copie ce token (tu ne pourras plus le voir)
   - **Project Key** : note-le (ex: `username_sonarqube-demo`)
   - **Organization** : note-le (généralement ton username GitHub)

## 🔐 Configuration GitHub Secrets

### Ajouter les secrets nécessaires

1. Va sur ton repository GitHub
2. Clique sur **Settings** (en haut)
3. Dans le menu de gauche, clique sur **Secrets and variables** → **Actions**
4. Clique sur **"New repository secret"** et ajoute les secrets suivants :

#### Secret 1 : SONAR_TOKEN

- **Name** : `SONAR_TOKEN`
- **Secret** : Colle le token de SonarCloud (ex: `sqp_1a2b3c4d5e6f...`)
- ⚠️ **Attention** : Colle UNIQUEMENT la valeur du token, sans `SONAR_TOKEN:` devant !

#### Secret 2 : SONAR_ORGANIZATION

- **Name** : `SONAR_ORGANIZATION`
- **Secret** : Ton nom d'organisation SonarCloud (généralement ton username GitHub)

#### Secret 3 : SONAR_PROJECT_KEY

- **Name** : `SONAR_PROJECT_KEY`
- **Secret** : La clé du projet (ex: `username_sonarqube-demo`)

### Exemple de configuration correcte :

```
✅ Correct :
Name: SONAR_TOKEN
Secret: sqp_1a2b3c4d5e6f7g8h9i0j

❌ Incorrect :
Name: SONAR_TOKEN
Secret: SONAR_TOKEN:sqp_1a2b3c4d5e6f7g8h9i0j
```

## 📁 Structure du projet

```
sonarqube-demo/
├── .github/
│   └── workflows/
│       └── sonarcloud.yml          # Workflow GitHub Actions
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── com/example/sonarqubedemo/
│   │   │       ├── SonarqubeDemoApplication.java
│   │   │       ├── controller/
│   │   │       │   └── UserController.java
│   │   │       ├── model/
│   │   │       │   └── User.java
│   │   │       ├── repository/
│   │   │       │   └── UserRepository.java
│   │   │       └── service/
│   │   │           └── UserService.java
│   │   └── resources/
│   │       └── application.properties
│   └── test/
│       └── java/
│           └── com/example/sonarqubedemo/
│               └── service/
│                   └── UserServiceTest.java
├── pom.xml
├── .gitignore
└── README.md
```

## 💻 Installation locale

### 1. Cloner le repository

```bash
git clone https://github.com/TON_USERNAME/sonarqube-demo.git
cd sonarqube-demo
```

### 2. Mettre à jour le pom.xml

Ouvre le fichier `pom.xml` et remplace :

```xml
<properties>
    <sonar.organization>YOUR_SONARCLOUD_ORG</sonar.organization>
    <sonar.projectKey>YOUR_PROJECT_KEY</sonar.projectKey>
</properties>
```

Par tes vraies valeurs :

```xml
<properties>
    <sonar.organization>ton-username-github</sonar.organization>
    <sonar.projectKey>ton-username_sonarqube-demo</sonar.projectKey>
</properties>
```

### 3. Compiler le projet

```bash
mvn clean install
```

### 4. Lancer l'application

```bash
mvn spring-boot:run
```

L'application sera accessible sur : **http://localhost:8080**

### 5. Tester les endpoints

```bash
# Créer un utilisateur
curl -X POST http://localhost:8080/api/users \
  -H "Content-Type: application/json" \
  -d '{"name":"John Doe","email":"john@example.com","phone":"123456789"}'

# Récupérer tous les utilisateurs
curl http://localhost:8080/api/users
```

## 🚀 Comment ça marche

### Déclenchement automatique

Le workflow GitHub Actions se déclenche automatiquement lors de :

1. **Push** sur les branches `main` ou `develop`
2. **Pull Request** (ouverture ou mise à jour)

### Processus d'analyse

Quand tu pushs du code :

1. GitHub Actions détecte le push
2. Le workflow démarre et :
   - Récupère le code
   - Configure Java 17
   - Compile le projet avec Maven
   - Lance les tests
   - Génère le rapport de couverture (JaCoCo)
   - Envoie tout à SonarCloud pour analyse
3. SonarCloud analyse le code et génère un rapport
4. Le résultat est visible dans GitHub (check vert/rouge)

### Ce que SonarCloud détecte

Le code contient volontairement des problèmes pour la démonstration :

- ✅ **Security Hotspot** : Mot de passe en dur dans `UserService`
- ✅ **Code Smell** : Code dupliqué dans `formatUserInfo()` et `formatUserDetails()`
- ✅ **Code Smell** : Utilisation de `@Autowired` au lieu de l'injection par constructeur
- ✅ **Bug potentiel** : Comparaison avec `== null` au lieu de `Objects.isNull()`

## 📊 Visualiser les résultats

### Sur GitHub

1. Va sur ton repository
2. Clique sur **"Actions"**
3. Sélectionne un workflow run
4. Tu verras si l'analyse a réussi ou échoué

### Sur SonarCloud

1. Va sur **https://sonarcloud.io**
2. Sélectionne ton projet
3. Tu verras :
   - **Bugs** : Erreurs potentielles
   - **Vulnerabilities** : Failles de sécurité
   - **Code Smells** : Mauvaises pratiques
   - **Coverage** : Couverture de tests
   - **Duplications** : Code dupliqué

### Badge SonarCloud

Tu peux ajouter un badge dans ton README :

```markdown
[![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=TON_PROJECT_KEY&metric=alert_status)](https://sonarcloud.io/summary/new_code?id=TON_PROJECT_KEY)
```

## 🎓 Pour aller plus loin

### Corriger les problèmes détectés

1. Regarde les issues dans SonarCloud
2. Corrige le code
3. Commit et push
4. GitHub Actions va relancer l'analyse automatiquement

### Exemple de correction - UserService.java

**Avant (avec problèmes) :**

```java
@Autowired
private UserRepository userRepository;

public User createUser(User user) {
    String password = "hardcoded_password"; // Security Hotspot
    if (user.getEmail() == null) {
        throw new IllegalArgumentException("Email cannot be null");
    }
    return userRepository.save(user);
}
```

**Après (corrigé) :**

```java
private final UserRepository userRepository;

public UserService(UserRepository userRepository) {
    this.userRepository = userRepository;
}

public User createUser(User user) {
    if (Objects.isNull(user.getEmail())) {
        throw new IllegalArgumentException("Email cannot be null");
    }
    return userRepository.save(user);
}
```

## 🤝 Contribuer

1. Fork le projet
2. Crée une branche (`git checkout -b feature/amelioration`)
3. Commit tes changements (`git commit -m 'Ajout fonctionnalité'`)
4. Push vers la branche (`git push origin feature/amelioration`)
5. Ouvre une Pull Request

SonarCloud analysera automatiquement ta PR !

## 📝 Licence

Ce projet est sous licence MIT.

## 👨‍💻 Auteur

Créé par **Abdoulaye** - Démonstration pour le Club Informatique UASZ

---

**Note** : Ce projet contient volontairement des problèmes de code pour démontrer les capacités de SonarQube. Ne pas utiliser en production ! 😉
