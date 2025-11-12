#!/bin/bash

echo "🚀 Script de déploiement SonarQube Demo"
echo "========================================"
echo ""

# Couleurs pour l'affichage
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Vérifier si git est installé
if ! command -v git &> /dev/null; then
    echo -e "${RED}❌ Git n'est pas installé${NC}"
    exit 1
fi

echo -e "${YELLOW}📝 Étape 1 : Initialisation du repository Git${NC}"
git init
git add .
git commit -m "Initial commit - SonarQube Demo"

echo ""
echo -e "${GREEN}✅ Repository Git initialisé${NC}"
echo ""

echo -e "${YELLOW}🔗 Étape 2 : Configuration du repository distant${NC}"
echo ""
echo "Veuillez créer un nouveau repository sur GitHub :"
echo "1. Va sur https://github.com/new"
echo "2. Nom du repository : sonarqube-demo"
echo "3. Choisis 'Public' (pour utiliser SonarCloud gratuitement)"
echo "4. Ne coche PAS 'Initialize with README'"
echo "5. Clique sur 'Create repository'"
echo ""
read -p "As-tu créé le repository sur GitHub ? (o/n) " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Oo]$ ]]; then
    echo -e "${RED}❌ Crée d'abord le repository sur GitHub${NC}"
    exit 1
fi

echo ""
read -p "Entre ton nom d'utilisateur GitHub : " github_username
echo ""

# Ajouter le remote
git remote add origin "https://github.com/$github_username/sonarqube-demo.git"
git branch -M main

echo ""
echo -e "${GREEN}✅ Remote configuré${NC}"
echo ""

echo -e "${YELLOW}☁️ Étape 3 : Configuration SonarCloud${NC}"
echo ""
echo "Maintenant, configure SonarCloud :"
echo "1. Va sur https://sonarcloud.io"
echo "2. Connecte-toi avec GitHub"
echo "3. Clique sur '+' → 'Analyze new project'"
echo "4. Sélectionne le repository 'sonarqube-demo'"
echo "5. Note les informations suivantes :"
echo ""
read -p "SONAR_TOKEN (commence par sqp_) : " sonar_token
read -p "SONAR_ORGANIZATION (ton username GitHub) : " sonar_org
read -p "SONAR_PROJECT_KEY (ex: username_sonarqube-demo) : " sonar_key
echo ""

echo -e "${YELLOW}🔐 Étape 4 : Configuration des secrets GitHub${NC}"
echo ""
echo "Va sur ton repository GitHub et configure les secrets :"
echo "1. Settings → Secrets and variables → Actions"
echo "2. Clique sur 'New repository secret' pour chaque secret :"
echo ""
echo "   Secret 1:"
echo "   Name: SONAR_TOKEN"
echo "   Value: $sonar_token"
echo ""
echo "   Secret 2:"
echo "   Name: SONAR_ORGANIZATION"
echo "   Value: $sonar_org"
echo ""
echo "   Secret 3:"
echo "   Name: SONAR_PROJECT_KEY"
echo "   Value: $sonar_key"
echo ""
read -p "As-tu configuré tous les secrets ? (o/n) " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Oo]$ ]]; then
    echo -e "${RED}❌ Configure d'abord les secrets sur GitHub${NC}"
    exit 1
fi

echo ""
echo -e "${YELLOW}📝 Étape 5 : Mise à jour du pom.xml${NC}"
echo ""

# Mettre à jour le pom.xml avec les vraies valeurs
sed -i "s/YOUR_SONARCLOUD_ORG/$sonar_org/g" pom.xml
sed -i "s/YOUR_PROJECT_KEY/$sonar_key/g" pom.xml

echo -e "${GREEN}✅ pom.xml mis à jour${NC}"
echo ""

# Commit des modifications
git add pom.xml
git commit -m "Update SonarCloud configuration"

echo -e "${YELLOW}🚀 Étape 6 : Push vers GitHub${NC}"
echo ""
git push -u origin main

echo ""
echo -e "${GREEN}🎉 Déploiement terminé !${NC}"
echo ""
echo "═══════════════════════════════════════════════════════"
echo "📊 Prochaines étapes :"
echo "═══════════════════════════════════════════════════════"
echo ""
echo "1. Va sur GitHub Actions pour voir l'analyse en cours :"
echo "   https://github.com/$github_username/sonarqube-demo/actions"
echo ""
echo "2. Va sur SonarCloud pour voir les résultats :"
echo "   https://sonarcloud.io/project/overview?id=$sonar_key"
echo ""
echo "3. Pour tester en local :"
echo "   mvn clean install"
echo "   mvn spring-boot:run"
echo ""
echo "4. Teste les endpoints :"
echo "   curl http://localhost:8080/api/users"
echo ""
echo "═══════════════════════════════════════════════════════"
echo -e "${GREEN}✨ Bonne démonstration !${NC}"
echo "═══════════════════════════════════════════════════════"
