# AI Integration Specification

## Overview
Currently, the app uses `FakeAiRecipeService` to return hardcoded recipes. This specification details the plan to integrate the Google Gemini API to generate dynamic, context-aware recipes based on user-provided ingredients and meal types.

## Architecture Changes

### 1. API Client Setup
- **Dependency**: Add `google_generative_ai` package.
- **Configuration**: Securely manage API keys (e.g., using `--dart-define` or a `.env` file, ensuring it's not committed to version control).

### 2. Service Implementation
- **Class**: `GeminiRecipeService` implementing `AiRecipeService`.
- **Prompt Engineering**:
    - Construct a structured prompt including:
        - List of available ingredients.
        - Selected meal type (Breakfast, Lunch, Dinner).
        - Dietary restrictions (if added in future).
        - Request for JSON output format to easily parse into `Recipe` objects.
- **Response Parsing**:
    - Implement robust JSON parsing to handle potential AI formatting inconsistencies.
    - Fallback mechanism or retry logic for malformed responses.

### 3. Data Layer Integration
- Update `RecipeRepository` to use `GeminiRecipeService` when the "Generate" feature is triggered.

## Prompt Template Draft
```text
You are a professional chef. Create 3 unique recipes using the following ingredients: [INGREDIENTS_LIST].
The meal type is: [MEAL_TYPE].
You may assume common pantry items (salt, pepper, oil, water) are available.

Return the response strictly as a JSON list of objects with the following structure:
[
  {
    "id": "unique_id",
    "name": "Recipe Name",
    "description": "Brief description",
    "cookingTimeMinutes": 30,
    "difficulty": "easy|medium|hard",
    "calories": 500,
    "ingredients": [{"name": "Ingredient 1", "amount": "1 cup"}],
    "steps": ["Step 1", "Step 2"],
    "nutrition": {"calories": 500, "protein": 20, "carbs": 50, "fat": 15}
  }
]
```

## Security Considerations
- API Key restrictions (restrict to Android/iOS bundle IDs).
- Rate limiting handling on the client side.
