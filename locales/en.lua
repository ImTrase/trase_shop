while not Config do Wait(100) end
if Config.Lang ~= 'en' then return end

Config.Locales = {
    -- General Titles
    ['error'] = 'Error',
    ['success'] = 'Success',
    ['player'] = 'Player',
    ['reward'] = 'Reward',
    ['day'] = 'Day',
    ['package'] = 'Package',
    ['price'] = 'Price',
    ['player_identifiers'] = 'Player Identifiers',
    ['where'] = 'Where',
    ['reason'] = 'Reason',
    ['line'] = 'Line',

    -- Debug Messages
    ['xPlayer_nil'] = 'xPlayer was nil in %s',
    ['source_nil'] = 'Source was nil in %s',
    ['amount_nil'] = 'Amount was nil in %s',
    ['identifier_nil'] = 'Identifier was nil in %s',

    -- Playtime Notifications
    ['playtime_notification_title'] = 'Playtime',
    ['playtime_notification_description'] = 'You have played for %s days, %s hours, %s minutes, and %s seconds.',
    ['playtime_error_title'] = 'Error',
    ['playtime_error_description'] = 'We could not find your playtime.',
    ['playtime_saved'] = 'Playtime for all players saved successfully.',
    ['playtime_inserted'] = 'Inserted playtime for %s',
    ['playtime_updated'] = 'Updated playtime for %s',
    ['playtime_format'] = '%sd %sh %smins',

    -- Daily Rewards
    ['daily_reward_claimed'] = 'Daily Reward Claimed',
    ['daily_reward_claimed_desc'] = 'has claimed their daily reward.',

    -- Shop
    ['not_enough_coins'] = 'You do not have enough coins to purchase this item.',
    ['item_purchased'] = 'You have successfully purchased the package.',
    ['coins_added'] = 'You have added %s coins to %s.',
    ['coins_received'] = 'You have received %s coins.',

    -- Package Purchase
    ['package_purchased'] = 'Package Purchased',
    ['package_purchased_desc'] = 'has purchased the %s package.',

    -- Database
    ['added_coins_column'] = 'The `coins` column was added to the `users` table.',
    ['created_dailyrewards_table'] = 'The `trase_dailyrewards` table was created.',
    ['created_playtime_table'] = 'The `trase_playtime` table was created.',

    -- Json
    ['created_coins_json'] = 'Created `coins.json` file for storing player coin data.',
    ['created_daily_rewards_json'] = 'Created `daily_rewards.json` file for storing daily rewards data.',
    ['created_playtime_json'] = 'Created `playtime.json` file for storing player playtime data.',

    -- Errors
    ['error_src_nil'] = 'src was nil',
    ['error_discord_not_started'] = 'Discord resource is not started.',
    ['error_identifier_nil'] = 'Identifier was nil.',

    -- UI Display
    ['store_title'] = 'Store',
    ['daily_rewards'] = 'Daily Rewards',

    ['information_title'] = 'Information',
    ['information_description'] = 'Unlock exclusive perks every day. Enjoy bonuses that enhance your experience, and make each day special with our rewarding system.',
    ['vip_only_tooltip'] = 'VIP only, you cannot access this',

    ['playtime_shop_title'] = 'Playtime Shop',
    ['purchase_button'] = 'Purchase',
    ['top_players_title'] = 'Top Players',
    ['coins_label'] = 'Coins',

    ['selected_title'] = 'REVIEW PURCHASE',
    ['back'] = 'Back',
    ['contains'] = 'Contains',
    ['buy_now'] = 'Buy Now',
    ['cannot_buy'] = 'Cannot Afford',
    ['escape'] = 'ESC',
    ['close'] = 'Close Menu',
}