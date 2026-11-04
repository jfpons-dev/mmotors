
## Backend FastAPI

Backend de l'application M-Motors, développé en Python avec FastAPI et destiné à être déployé sur AWS ECS Fargate.
La version actuelle expose une route GET / permettant de vérifier le fonctionnement de l'application. Le projet utilise Docker pour la conteneurisation, Amazon ECR pour le stockage des images et GitHub Actions pour l'automatisation des déploiements.

### Prérequis

- Python 3
- Docker

### Installation

Depuis la racine du projet :

```bash
cd backend
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

### Lancer l'application

```bash
uvicorn main:app --reload
```

L'API est accessible à l'adresse : http://localhost:8000

### Exécuter les tests

```bash
pip install pytest httpx
python -m pytest -v
```

### Construire l'image Docker

```bash
docker build --platform linux/amd64 -t m-motors-api .
```

### Lancer le conteneur

```bash
docker run --rm --platform linux/amd64 -p 8000:8000 m-motors-api
```

L'application est accessible sur http://localhost:8000.



## Publication dans Amazon ECR

Prérequis : AWS CLI configuré et dépôt ECR créé.

### Se connecter à ECR

```bash
aws ecr get-login-password --region eu-west-3 | docker login --username AWS --password-stdin 587815505272.dkr.ecr.eu-west-3.amazonaws.com
```

### Donner à l'image locale son tag ECR

```bash
docker tag m-motors-api:latest 587815505272.dkr.ecr.eu-west-3.amazonaws.com/m-motors-api:v3
```

### Publier l'image

```bash
docker push 587815505272.dkr.ecr.eu-west-3.amazonaws.com/m-motors-api:v3
```

### Vérifier la publication

```bash
aws ecr describe-images --repository-name m-motors-api --image-ids imageTag=v3 --region eu-west-3
```

Le dépôt ECR utilise des tags immuables. Il faut utiliser un nouveau numéro de version à chaque publication.

