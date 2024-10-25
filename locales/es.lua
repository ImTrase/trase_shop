while not Config do Wait(100) end
if Config.Lang ~= 'es' then return end

Config.Locales = {
    -- General Titles
    ['error'] = 'Error',
    ['success'] = 'Éxito',
    ['player'] = 'Jugador',
    ['reward'] = 'Recompensa',
    ['day'] = 'Día',
    ['package'] = 'Paquete',
    ['price'] = 'Precio',
    ['player_identifiers'] = 'Identificadores del Jugador',
    ['where'] = 'Dónde',
    ['reason'] = 'Razón',
    ['line'] = 'Línea',

    -- Debug Messages
    ['xPlayer_nil'] = 'xPlayer era nulo en %s',
    ['source_nil'] = 'Source era nulo en %s',
    ['amount_nil'] = 'La cantidad era nula en %s',
    ['identifier_nil'] = 'El identificador era nulo en %s',

    -- Playtime Notifications
    ['playtime_notification_title'] = 'Tiempo de juego',
    ['playtime_notification_description'] = 'Has jugado por %s días, %s horas, %s minutos, y %s segundos.',
    ['playtime_error_title'] = 'Error',
    ['playtime_error_description'] = 'No pudimos encontrar tu tiempo de juego.',
    ['playtime_saved'] = 'Tiempo de juego guardado con éxito para todos los jugadores.',
    ['playtime_inserted'] = 'Tiempo de juego insertado para %s',
    ['playtime_updated'] = 'Tiempo de juego actualizado para %s',
    ['playtime_format'] = '%sd %sh %smins',

    -- Daily Rewards
    ['daily_reward_claimed'] = 'Recompensa Diaria Reclamada',
    ['daily_reward_claimed_desc'] = 'ha reclamado su recompensa diaria.',

    -- Shop
    ['not_enough_coins'] = 'No tienes suficientes monedas para comprar este artículo.',
    ['item_purchased'] = 'Has comprado el paquete con éxito.',
    ['coins_added'] = 'Has agregado %s monedas a %s.',
    ['coins_received'] = 'Has recibido %s monedas.',

    -- Package Purchase
    ['package_purchased'] = 'Paquete Comprado',
    ['package_purchased_desc'] = 'ha comprado el paquete %s.',

    -- Database
    ['added_coins_column'] = 'La columna `coins` fue añadida a la tabla `users`.',
    ['created_dailyrewards_table'] = 'La tabla `trase_dailyrewards` fue creada.',
    ['created_playtime_table'] = 'La tabla `trase_playtime` fue creada.',

    -- Json
    ['created_coins_json'] = 'Archivo `coins.json` creado para almacenar datos de monedas de los jugadores.',
    ['created_daily_rewards_json'] = 'Archivo `daily_rewards.json` creado para almacenar datos de recompensas diarias.',
    ['created_playtime_json'] = 'Archivo `playtime.json` creado para almacenar datos de tiempo de juego de los jugadores.',

    -- Errors
    ['error_src_nil'] = 'src era nulo',
    ['error_discord_not_started'] = 'El recurso Discord no está iniciado.',
    ['error_identifier_nil'] = 'El identificador era nulo.',

    -- UI Display
    ['store_title'] = 'Tienda',
    ['daily_rewards'] = 'Recompensas Diarias',

    ['information_title'] = 'Información',
    ['information_description'] = 'Desbloquea ventajas exclusivas cada día. Disfruta de bonificaciones que mejoran tu experiencia y haz que cada día sea especial con nuestro sistema de recompensas.',
    ['vip_only_tooltip'] = 'Solo para VIP, no puedes acceder a esto',

    ['playtime_shop_title'] = 'Tienda de Tiempo de Juego',
    ['purchase_button'] = 'Comprar',
    ['top_players_title'] = 'Mejores Jugadores',
    ['coins_label'] = 'Monedas',

    ['selected_title'] = 'REVISAR COMPRA',
    ['back'] = 'Volver',
    ['contains'] = 'Contiene',
    ['buy_now'] = 'Comprar Ahora',
    ['cannot_buy'] = 'No Puedes Comprar',
    ['escape'] = 'ESC',
    ['close'] = 'Cerrar Menú',
}