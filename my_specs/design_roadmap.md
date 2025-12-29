# Design Roadmap (HTML Screen Designs)

Status legend:
- done: screen/state implemented in Flutter UI
- not yet: screen/state not implemented or incomplete in Flutter UI

Source: `design/` HTML screen designs.

| Priority | Feature (Design) | Status | Notes |
| --- | --- | --- | --- |
| High | home_screen | done | `lib/presentation/screens/home_screen.dart` |
| High | scan_screen_-_normal_state | not yet | Core scan UI exists, but gallery picker is TODO and state is incomplete |
| High | recipe_suggestions_-_normal | done | `lib/presentation/screens/recipe_suggestions_screen.dart` |
| High | recipe_detail_-_normal | done | `lib/presentation/screens/recipe_detail_screen.dart` |
| High | create_/_edit_recipe_-_normal | done | `lib/presentation/screens/create_recipe_screen.dart` |
| High | my_recipes_-_normal | done | `lib/presentation/screens/my_recipes_screen.dart` |
| High | shopping_list_-_normal | not yet | `lib/presentation/screens/shopping_list_screen.dart` is placeholder |
| High | ingredient_management_1 | not yet | No standalone ingredient management screen |
| High | ingredient_management_2 | not yet | No standalone ingredient management screen |
| High | ingredient_management_3 | not yet | No standalone ingredient management screen |
| High | ingredient_management_4 | not yet | No standalone ingredient management screen |
| High | edit_ingredient_screen_-_fresh | not yet | No standalone edit ingredient screen |
| Medium | scan_screen_-_camera_unavailable | done | `lib/presentation/screens/scan_screen.dart` |
| Medium | scan_screen_-_permission_denied | not yet | No dedicated permission-denied UI; uses generic unavailable state |
| Medium | scan_screen_-_initializing_state | done | Skeleton loading in `lib/presentation/screens/scan_screen.dart` |
| Medium | recipe_suggestions_-_loading | done | Skeleton grid in `lib/presentation/screens/recipe_suggestions_screen.dart` |
| Medium | recipe_suggestions_-_error_state | done | Error state + retry in `lib/presentation/screens/recipe_suggestions_screen.dart` |
| Medium | recipe_suggestions_-_empty_state | done | Empty state in `lib/presentation/screens/recipe_suggestions_screen.dart` |
| Medium | recipe_suggestions_-_ai_disabled | done | AI disabled screen in `lib/presentation/screens/recipe_suggestions_screen.dart` |
| Medium | my_recipes_-_empty_state | done | Empty state in `lib/presentation/screens/my_recipes_screen.dart` |
| Medium | my_recipes_-_error_state | done | Error state in `lib/presentation/screens/my_recipes_screen.dart` |
| Medium | create_/_edit_recipe_-_images_disabled | done | Feature-flagged disabled state in `lib/presentation/screens/create_recipe_screen.dart` |
| Medium | shopping_list_-_empty_state | not yet | No empty state yet |
| Medium | recipe_detail_-_error_state | not yet | No error state yet |
| Medium | recipe_detail_-_empty_state | not yet | No empty state yet |
| Medium | home_screen_-_loading_state | not yet | Only the suggested section has a skeleton, not full loading state |
| Medium | home_screen_-_empty_state | not yet | No empty state yet |
| Low | scan_screen_-_disabled_state | not yet | No disabled state toggle in UI |
| Low | welcome_screen_-_onboarding | not yet | Onboarding screen not implemented |
| Low | login_screen | not yet | Login screen not implemented |
| Low | sign_up_screen | not yet | Sign-up screen not implemented |
| Low | user_profile_screen | not yet | Profile screen not implemented |
| Low | privacy_policy_modal | done | Privacy modal in `lib/presentation/screens/home_screen.dart` |
