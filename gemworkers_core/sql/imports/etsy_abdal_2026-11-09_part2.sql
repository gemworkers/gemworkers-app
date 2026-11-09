-- Abdal Shop Etsy import, PART 2 of 3 (250 drafts, unlisted; USD→EUR at ECB 1.1193). Run parts in order. Safe to run twice.
BEGIN;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('db3af66d-b496-4b21-a589-a61673bcf654', '3.35 Cts Apple Green Tourmaline', 'Mesmerising Apple 🍏 Green Colour Afghan Tourmaline

Rare Colour 

Ethically Sourced

high lustre and brilliance 

3.35 cts
9 x 8 x 5.9 mm

Unheated, No treatment Whatsoever.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 267, 1, 'loose_stone', 'Tourmaline', NULL, 3.35, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/db3af66d-b496-4b21-a589-a61673bcf654/etsy-1.jpg","https://media.gemworkers.com/items/db3af66d-b496-4b21-a589-a61673bcf654/etsy-2.jpg","https://media.gemworkers.com/items/db3af66d-b496-4b21-a589-a61673bcf654/etsy-3.jpg","https://media.gemworkers.com/items/db3af66d-b496-4b21-a589-a61673bcf654/etsy-4.jpg","https://media.gemworkers.com/items/db3af66d-b496-4b21-a589-a61673bcf654/etsy-5.jpg","https://media.gemworkers.com/items/db3af66d-b496-4b21-a589-a61673bcf654/etsy-6.jpg","https://media.gemworkers.com/items/db3af66d-b496-4b21-a589-a61673bcf654/etsy-7.jpg","https://media.gemworkers.com/items/db3af66d-b496-4b21-a589-a61673bcf654/etsy-8.jpg","https://media.gemworkers.com/items/db3af66d-b496-4b21-a589-a61673bcf654/etsy-9.jpg","https://media.gemworkers.com/items/db3af66d-b496-4b21-a589-a61673bcf654/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 299 USD, converted at ECB rate. Etsy tags: Jewellery Making,Rings For Women,Jewellery Finding,Rings For Men,Jewels,Gold Rings,Jewellery Supplies,Gift For Her,Natural Stone,Blue tourmaline,lagoon Tourmaline,Oceangemsminerals,AppleGreenTourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('73505a65-269e-4b1a-9fb0-7af2b641473e', '9.3 Cts Neon Blue Tourmaline Lot', 'lagoon and neon blue colour tourmaline Lot

top colour high lustre and brilliance 

9.30 cts
4.7mm to 15.7mm

100% natural no treatment whatsoever.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 535, 1, 'loose_stone', 'Tourmaline', NULL, 9.3, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/73505a65-269e-4b1a-9fb0-7af2b641473e/etsy-1.jpg","https://media.gemworkers.com/items/73505a65-269e-4b1a-9fb0-7af2b641473e/etsy-2.jpg","https://media.gemworkers.com/items/73505a65-269e-4b1a-9fb0-7af2b641473e/etsy-3.jpg","https://media.gemworkers.com/items/73505a65-269e-4b1a-9fb0-7af2b641473e/etsy-4.jpg","https://media.gemworkers.com/items/73505a65-269e-4b1a-9fb0-7af2b641473e/etsy-5.jpg","https://media.gemworkers.com/items/73505a65-269e-4b1a-9fb0-7af2b641473e/etsy-6.jpg","https://media.gemworkers.com/items/73505a65-269e-4b1a-9fb0-7af2b641473e/etsy-7.jpg","https://media.gemworkers.com/items/73505a65-269e-4b1a-9fb0-7af2b641473e/etsy-8.jpg","https://media.gemworkers.com/items/73505a65-269e-4b1a-9fb0-7af2b641473e/etsy-9.jpg","https://media.gemworkers.com/items/73505a65-269e-4b1a-9fb0-7af2b641473e/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 599 USD, converted at ECB rate. Etsy tags: Natural Stone,Jewellery Supplies,Jewellery Making,Jewellery Findings,y2k stud earrings,Gift For Her,Rings For Men,Rings For Women,Gold Rings,Silver Sterling,Garnet Necklace,Garnet Rings,Garnet Jewellery.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('3a245493-615a-463c-9846-2b59ef91e86d', '2.7 Cts Apple Green Tourmaline', 'Mesmerising Apple 🍏 Green Colour Afghan Tourmaline

Rare Colour 

Ethically Sourced

high lustre and brilliance 

2.70 cts
9.7 x 6.8 x 4.9 mm

Unheated, No treatment Whatsoever.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 241, 1, 'loose_stone', 'Tourmaline', NULL, 2.7, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/3a245493-615a-463c-9846-2b59ef91e86d/etsy-1.jpg","https://media.gemworkers.com/items/3a245493-615a-463c-9846-2b59ef91e86d/etsy-2.jpg","https://media.gemworkers.com/items/3a245493-615a-463c-9846-2b59ef91e86d/etsy-3.jpg","https://media.gemworkers.com/items/3a245493-615a-463c-9846-2b59ef91e86d/etsy-4.jpg","https://media.gemworkers.com/items/3a245493-615a-463c-9846-2b59ef91e86d/etsy-5.jpg","https://media.gemworkers.com/items/3a245493-615a-463c-9846-2b59ef91e86d/etsy-6.jpg","https://media.gemworkers.com/items/3a245493-615a-463c-9846-2b59ef91e86d/etsy-7.jpg","https://media.gemworkers.com/items/3a245493-615a-463c-9846-2b59ef91e86d/etsy-8.jpg","https://media.gemworkers.com/items/3a245493-615a-463c-9846-2b59ef91e86d/etsy-9.jpg","https://media.gemworkers.com/items/3a245493-615a-463c-9846-2b59ef91e86d/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 270 USD, converted at ECB rate. Etsy tags: Jewellery Making,Rings For Women,Jewellery Finding,Rings For Men,Jewels,Gold Rings,Jewellery Supplies,Gift For Her,Natural Stone,Blue tourmaline,lagoon Tourmaline,Oceangemsminerals,AppleGreenTourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('f718fffd-0fba-499e-9887-129e9c291d10', '1.3 Cts teal blue Tourmaline', 'Teal blue colour tourmaline

mesmerising rare colour, cute looking tourmaline.

1.30 cts
7.3x4.8x3.9mm

no treatment whatsoever.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 178, 1, 'loose_stone', 'Tourmaline', NULL, 1.3, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/f718fffd-0fba-499e-9887-129e9c291d10/etsy-1.jpg","https://media.gemworkers.com/items/f718fffd-0fba-499e-9887-129e9c291d10/etsy-2.jpg","https://media.gemworkers.com/items/f718fffd-0fba-499e-9887-129e9c291d10/etsy-3.jpg","https://media.gemworkers.com/items/f718fffd-0fba-499e-9887-129e9c291d10/etsy-4.jpg","https://media.gemworkers.com/items/f718fffd-0fba-499e-9887-129e9c291d10/etsy-5.jpg","https://media.gemworkers.com/items/f718fffd-0fba-499e-9887-129e9c291d10/etsy-6.jpg","https://media.gemworkers.com/items/f718fffd-0fba-499e-9887-129e9c291d10/etsy-7.jpg","https://media.gemworkers.com/items/f718fffd-0fba-499e-9887-129e9c291d10/etsy-8.jpg","https://media.gemworkers.com/items/f718fffd-0fba-499e-9887-129e9c291d10/etsy-9.jpg","https://media.gemworkers.com/items/f718fffd-0fba-499e-9887-129e9c291d10/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 199 USD, converted at ECB rate. Etsy tags: Tourmaline Jewellery,Tourmaline Rings,Blue Tourmaline,Gift For Her,Rings For Women,Rings For Men,Gold Rings,Natural Stone,lagoon tourmaline,indigo tourmaline,indicolitetourmaline,Oceangemsminerals,ink blue tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('024fc11f-8931-4f39-9a7a-444f456996bc', '5.80 Cts Pink Tourmaline Pairs', 'Gorgeous Pink Tourmaline Pairs Fancy Cut

Loupe Clean

5.80 Cts
5.9 x 5.5 x 4.4mm
5.7 x 5.4 x 4.3mm
4.8 x 4.4 x 3.2mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 536, 1, 'loose_stone', 'Tourmaline', NULL, 5.8, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/024fc11f-8931-4f39-9a7a-444f456996bc/etsy-1.jpg","https://media.gemworkers.com/items/024fc11f-8931-4f39-9a7a-444f456996bc/etsy-2.jpg","https://media.gemworkers.com/items/024fc11f-8931-4f39-9a7a-444f456996bc/etsy-3.jpg","https://media.gemworkers.com/items/024fc11f-8931-4f39-9a7a-444f456996bc/etsy-4.jpg","https://media.gemworkers.com/items/024fc11f-8931-4f39-9a7a-444f456996bc/etsy-5.jpg","https://media.gemworkers.com/items/024fc11f-8931-4f39-9a7a-444f456996bc/etsy-6.jpg","https://media.gemworkers.com/items/024fc11f-8931-4f39-9a7a-444f456996bc/etsy-7.jpg","https://media.gemworkers.com/items/024fc11f-8931-4f39-9a7a-444f456996bc/etsy-8.jpg","https://media.gemworkers.com/items/024fc11f-8931-4f39-9a7a-444f456996bc/etsy-9.jpg","https://media.gemworkers.com/items/024fc11f-8931-4f39-9a7a-444f456996bc/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 600 USD, converted at ECB rate. Etsy tags: pink tourmaline,rings for women,unique tourmaline,jewels,Handmadejewellery,gift for her,Topqualitytourmaline,Bicolour Tourmaline,Unique Bicolour,Rare Tourmaline,Oceangemsminerals,Tourmaline Pairs,Bicolour Pairs.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('42eb1aea-ae80-4efa-b36a-cf192a27c138', '8.40 Cts Green Bicolour Tourmaline Pairs', 'Gorgeous Green Bicolour Tourmaline Pairs 

8.40 Cts 
7.9x6.5x4.7mm 
9.5x5.5x3.5mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 179, 1, 'loose_stone', 'Tourmaline', NULL, 8.4, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/42eb1aea-ae80-4efa-b36a-cf192a27c138/etsy-1.jpg","https://media.gemworkers.com/items/42eb1aea-ae80-4efa-b36a-cf192a27c138/etsy-2.jpg","https://media.gemworkers.com/items/42eb1aea-ae80-4efa-b36a-cf192a27c138/etsy-3.jpg","https://media.gemworkers.com/items/42eb1aea-ae80-4efa-b36a-cf192a27c138/etsy-4.jpg","https://media.gemworkers.com/items/42eb1aea-ae80-4efa-b36a-cf192a27c138/etsy-5.jpg","https://media.gemworkers.com/items/42eb1aea-ae80-4efa-b36a-cf192a27c138/etsy-6.jpg","https://media.gemworkers.com/items/42eb1aea-ae80-4efa-b36a-cf192a27c138/etsy-7.jpg","https://media.gemworkers.com/items/42eb1aea-ae80-4efa-b36a-cf192a27c138/etsy-8.jpg","https://media.gemworkers.com/items/42eb1aea-ae80-4efa-b36a-cf192a27c138/etsy-9.jpg","https://media.gemworkers.com/items/42eb1aea-ae80-4efa-b36a-cf192a27c138/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 200 USD, converted at ECB rate. Etsy tags: pink tourmaline,rings for women,unique tourmaline,jewels,Handmadejewellery,gift for her,Topqualitytourmaline,Bicolour Tourmaline,Unique Bicolour,Rare Tourmaline,Oceangemsminerals,Tourmaline Pairs,Bicolour Pairs.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('8bb1f0bc-3217-4013-b888-5e654646ef60', '1.20 Cts Indigo blue Tourmaline', 'indigo blue colour tourmaline 

mesmerising rare colour, cute looking tourmaline.

1.20 Cts 
Size:6x5.7x4.4mm

no treatment whatsoever.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 223, 1, 'loose_stone', 'Tourmaline', NULL, 1.2, 'ct', NULL, NULL, '6x5.7x4.4', '["https://media.gemworkers.com/items/8bb1f0bc-3217-4013-b888-5e654646ef60/etsy-1.jpg","https://media.gemworkers.com/items/8bb1f0bc-3217-4013-b888-5e654646ef60/etsy-2.jpg","https://media.gemworkers.com/items/8bb1f0bc-3217-4013-b888-5e654646ef60/etsy-3.jpg","https://media.gemworkers.com/items/8bb1f0bc-3217-4013-b888-5e654646ef60/etsy-4.jpg","https://media.gemworkers.com/items/8bb1f0bc-3217-4013-b888-5e654646ef60/etsy-5.jpg","https://media.gemworkers.com/items/8bb1f0bc-3217-4013-b888-5e654646ef60/etsy-6.jpg","https://media.gemworkers.com/items/8bb1f0bc-3217-4013-b888-5e654646ef60/etsy-7.jpg","https://media.gemworkers.com/items/8bb1f0bc-3217-4013-b888-5e654646ef60/etsy-8.jpg","https://media.gemworkers.com/items/8bb1f0bc-3217-4013-b888-5e654646ef60/etsy-9.jpg","https://media.gemworkers.com/items/8bb1f0bc-3217-4013-b888-5e654646ef60/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 250 USD, converted at ECB rate. Etsy tags: Tourmaline Jewellery,Tourmaline Rings,Blue Tourmaline,Gift For Her,Rings For Women,Rings For Men,Gold Rings,Natural Stone,lagoon tourmaline,indigo tourmaline,indicolitetourmaline,Oceangemsminerals,ink blue tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('4e909a9c-f5eb-4b80-934e-ba915e7923cf', '8 Cts Tricolour Tourmaline', 'unique combinations tourmaline 

Very Bright And Glowing Polish 

At very reasonable price 

Good size and lustre

8 Cts
12.5 x 9 x 7.5mm

Unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 179, 1, 'loose_stone', 'Tourmaline', NULL, 8, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/4e909a9c-f5eb-4b80-934e-ba915e7923cf/etsy-1.jpg","https://media.gemworkers.com/items/4e909a9c-f5eb-4b80-934e-ba915e7923cf/etsy-2.jpg","https://media.gemworkers.com/items/4e909a9c-f5eb-4b80-934e-ba915e7923cf/etsy-3.jpg","https://media.gemworkers.com/items/4e909a9c-f5eb-4b80-934e-ba915e7923cf/etsy-4.jpg","https://media.gemworkers.com/items/4e909a9c-f5eb-4b80-934e-ba915e7923cf/etsy-5.jpg","https://media.gemworkers.com/items/4e909a9c-f5eb-4b80-934e-ba915e7923cf/etsy-6.jpg","https://media.gemworkers.com/items/4e909a9c-f5eb-4b80-934e-ba915e7923cf/etsy-7.jpg","https://media.gemworkers.com/items/4e909a9c-f5eb-4b80-934e-ba915e7923cf/etsy-8.jpg","https://media.gemworkers.com/items/4e909a9c-f5eb-4b80-934e-ba915e7923cf/etsy-9.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 200 USD, converted at ECB rate. Etsy tags: Tricolour Tourmaline,Tourmaline Pairs,Tricolour Pairs,Unique Tourmaline,Unique Pairs,Blue Tricolour Pairs,Blue tourmaline pair,Lagoon Tourmaline,Neon Tourmaline,Rare Tourmaline,Rare Tricolour Pairs,Oceangemsminerals,Ink blue Tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('027bc320-df1c-4be4-b4e1-852a0af99db6', '1.35 Cts Blue Bicolour Tourmaline', 'Bicolour Blue And Green Mesmerising Afghan Tourmaline 

1.35 Cts
9 x 4.5 x 3.7mm

glowing 

unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 161, 1, 'loose_stone', 'Tourmaline', NULL, 1.35, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/027bc320-df1c-4be4-b4e1-852a0af99db6/etsy-1.jpg","https://media.gemworkers.com/items/027bc320-df1c-4be4-b4e1-852a0af99db6/etsy-2.jpg","https://media.gemworkers.com/items/027bc320-df1c-4be4-b4e1-852a0af99db6/etsy-3.jpg","https://media.gemworkers.com/items/027bc320-df1c-4be4-b4e1-852a0af99db6/etsy-4.jpg","https://media.gemworkers.com/items/027bc320-df1c-4be4-b4e1-852a0af99db6/etsy-5.jpg","https://media.gemworkers.com/items/027bc320-df1c-4be4-b4e1-852a0af99db6/etsy-6.jpg","https://media.gemworkers.com/items/027bc320-df1c-4be4-b4e1-852a0af99db6/etsy-7.jpg","https://media.gemworkers.com/items/027bc320-df1c-4be4-b4e1-852a0af99db6/etsy-8.jpg","https://media.gemworkers.com/items/027bc320-df1c-4be4-b4e1-852a0af99db6/etsy-9.jpg","https://media.gemworkers.com/items/027bc320-df1c-4be4-b4e1-852a0af99db6/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 180 USD, converted at ECB rate. Etsy tags: Bicolour Tourmaline,Blue Tourmaline,Lagoon Tourmaline,Neon Tourmaline,Tourmaline jewellery,gift for her,natural stone,Tourmaline Rings,tourmaline necklace,rings for men,rings for women,jewellery making,jewellery supplies.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('e2b7066c-e681-4e2e-96d4-6775e490601c', '9.10 Cts Tricolour Tourmaline Pairs', 'To All The Bicolour Lovers Here Is An Incredible Opportunity Buy A Truly Exceptional And One Of A Kind Tricolour Tourmaline Pairs 

Purple, Pink, And Apple Green Combination 

9.10 Cts
9.2 x 6.8 x 4.5mm
8.4 x 5.6 x 4mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 322, 1, 'loose_stone', 'Tourmaline', NULL, 9.1, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/e2b7066c-e681-4e2e-96d4-6775e490601c/etsy-1.jpg","https://media.gemworkers.com/items/e2b7066c-e681-4e2e-96d4-6775e490601c/etsy-2.jpg","https://media.gemworkers.com/items/e2b7066c-e681-4e2e-96d4-6775e490601c/etsy-3.jpg","https://media.gemworkers.com/items/e2b7066c-e681-4e2e-96d4-6775e490601c/etsy-4.jpg","https://media.gemworkers.com/items/e2b7066c-e681-4e2e-96d4-6775e490601c/etsy-5.jpg","https://media.gemworkers.com/items/e2b7066c-e681-4e2e-96d4-6775e490601c/etsy-6.jpg","https://media.gemworkers.com/items/e2b7066c-e681-4e2e-96d4-6775e490601c/etsy-7.jpg","https://media.gemworkers.com/items/e2b7066c-e681-4e2e-96d4-6775e490601c/etsy-8.jpg","https://media.gemworkers.com/items/e2b7066c-e681-4e2e-96d4-6775e490601c/etsy-9.jpg","https://media.gemworkers.com/items/e2b7066c-e681-4e2e-96d4-6775e490601c/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 360 USD, converted at ECB rate. Etsy tags: pink tourmaline,rings for women,unique tourmaline,jewels,Handmadejewellery,gift for her,Topqualitytourmaline,Bicolour Tourmaline,Unique Bicolour,Rare Tourmaline,Oceangemsminerals,Tourmaline Pairs,Bicolour Pairs.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('38278e41-a6f3-4ca5-be50-c3d1c796f6d3', '7.7 Cts Canary Tourmaline Pair', 'Mesmerising Canary Colour Tourmaline Set For Earrings. 

Or it can be used for separate earrings. 

One of a kind! 
not a every day color that we get 

Super special and also eye clean to loupe clean.

4.60 Cts ( 12.5 x 6 x 5mm) peardrop
3.10 Cts ( 9 x 5.5 x 4.5mm) cushion 

No treatment. Unheated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 688, 1, 'loose_stone', 'Tourmaline', NULL, 7.7, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/38278e41-a6f3-4ca5-be50-c3d1c796f6d3/etsy-1.jpg","https://media.gemworkers.com/items/38278e41-a6f3-4ca5-be50-c3d1c796f6d3/etsy-2.jpg","https://media.gemworkers.com/items/38278e41-a6f3-4ca5-be50-c3d1c796f6d3/etsy-3.jpg","https://media.gemworkers.com/items/38278e41-a6f3-4ca5-be50-c3d1c796f6d3/etsy-4.jpg","https://media.gemworkers.com/items/38278e41-a6f3-4ca5-be50-c3d1c796f6d3/etsy-5.jpg","https://media.gemworkers.com/items/38278e41-a6f3-4ca5-be50-c3d1c796f6d3/etsy-6.jpg","https://media.gemworkers.com/items/38278e41-a6f3-4ca5-be50-c3d1c796f6d3/etsy-7.jpg","https://media.gemworkers.com/items/38278e41-a6f3-4ca5-be50-c3d1c796f6d3/etsy-8.jpg","https://media.gemworkers.com/items/38278e41-a6f3-4ca5-be50-c3d1c796f6d3/etsy-9.jpg","https://media.gemworkers.com/items/38278e41-a6f3-4ca5-be50-c3d1c796f6d3/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 770 USD, converted at ECB rate. Etsy tags: Honey Colour,Honey Tourmaline,Tourmaline Earrings,Tourmaline set,Special tourmaline,Rare tourmaline,Cushion cut,Peardrop shape,Natural stone,Gift for her,lagoon tourmaline,blue tourmaline,tourmaline rings.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('19bb5407-34c9-4fef-9193-2fc50e586138', '1.5 Cts Lagoon Tourmaline Pair', 'A Very High Lustre Lagoon Blue Colour Tourmaline Pairs

1.50 Cts
6 x 4.2 x 3.4mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 179, 1, 'loose_stone', 'Tourmaline', NULL, 1.5, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/19bb5407-34c9-4fef-9193-2fc50e586138/etsy-1.jpg","https://media.gemworkers.com/items/19bb5407-34c9-4fef-9193-2fc50e586138/etsy-2.jpg","https://media.gemworkers.com/items/19bb5407-34c9-4fef-9193-2fc50e586138/etsy-3.jpg","https://media.gemworkers.com/items/19bb5407-34c9-4fef-9193-2fc50e586138/etsy-4.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 200 USD, converted at ECB rate. Etsy tags: Tourmaline Earrings,Earrings Set,Fine Tourmaline,Canary Tourmaline,Lagoon Tourmaline,Blue Tourmaline,Yellow Tourmaline,Stud Earrings,Tourmaline Jewellery,Jewellery Set,Oceangemsminerals,Tourmaline Pairs,Lagoon Pairs.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('ed9a231a-c194-4dc6-8a66-e29040fe1a92', '2 Cts Lagoon Tourmaline Pairs', 'A Very High Lustre Lagoon Blue Colour Tourmaline Pairs

2 cts
5.4 x 3.7 x 3.2mm
4.6 x 3.8 x 3.2mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 313, 1, 'loose_stone', 'Tourmaline', NULL, 2, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/ed9a231a-c194-4dc6-8a66-e29040fe1a92/etsy-1.jpg","https://media.gemworkers.com/items/ed9a231a-c194-4dc6-8a66-e29040fe1a92/etsy-2.jpg","https://media.gemworkers.com/items/ed9a231a-c194-4dc6-8a66-e29040fe1a92/etsy-3.jpg","https://media.gemworkers.com/items/ed9a231a-c194-4dc6-8a66-e29040fe1a92/etsy-4.jpg","https://media.gemworkers.com/items/ed9a231a-c194-4dc6-8a66-e29040fe1a92/etsy-5.jpg","https://media.gemworkers.com/items/ed9a231a-c194-4dc6-8a66-e29040fe1a92/etsy-6.jpg","https://media.gemworkers.com/items/ed9a231a-c194-4dc6-8a66-e29040fe1a92/etsy-7.jpg","https://media.gemworkers.com/items/ed9a231a-c194-4dc6-8a66-e29040fe1a92/etsy-8.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 350 USD, converted at ECB rate. Etsy tags: Tourmaline Earrings,Earrings Set,Fine Tourmaline,Canary Tourmaline,Lagoon Tourmaline,Blue Tourmaline,Yellow Tourmaline,Stud Earrings,Tourmaline Jewellery,Jewellery Set,Oceangemsminerals,Tourmaline Pairs,Lagoon Pairs.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('7d8b71dd-fc93-4780-81fe-7c7b0cf020ac', '3.55 Cts Lagoon Tourmaline Pairs', 'A Very High Lustre Lagoon Blue Colour Tourmaline Pairs

3.55 Cts
8.5 x 4.1 x 3.4mm
5.6 x 4 x 2.9mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 313, 1, 'loose_stone', 'Tourmaline', NULL, 3.55, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/7d8b71dd-fc93-4780-81fe-7c7b0cf020ac/etsy-1.jpg","https://media.gemworkers.com/items/7d8b71dd-fc93-4780-81fe-7c7b0cf020ac/etsy-2.jpg","https://media.gemworkers.com/items/7d8b71dd-fc93-4780-81fe-7c7b0cf020ac/etsy-3.jpg","https://media.gemworkers.com/items/7d8b71dd-fc93-4780-81fe-7c7b0cf020ac/etsy-4.jpg","https://media.gemworkers.com/items/7d8b71dd-fc93-4780-81fe-7c7b0cf020ac/etsy-5.jpg","https://media.gemworkers.com/items/7d8b71dd-fc93-4780-81fe-7c7b0cf020ac/etsy-6.jpg","https://media.gemworkers.com/items/7d8b71dd-fc93-4780-81fe-7c7b0cf020ac/etsy-7.jpg","https://media.gemworkers.com/items/7d8b71dd-fc93-4780-81fe-7c7b0cf020ac/etsy-8.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 350 USD, converted at ECB rate. Etsy tags: Tourmaline Earrings,Earrings Set,Fine Tourmaline,Canary Tourmaline,Lagoon Tourmaline,Blue Tourmaline,Yellow Tourmaline,Stud Earrings,Tourmaline Jewellery,Jewellery Set,Oceangemsminerals,Tourmaline Pairs,Lagoon Pairs.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('277e3b31-6b7e-462b-ae98-e9220ac1b0e9', '1.30 Cts Blue Green Tourmaline', 'Mesmerising Blue and  Green Colour Tourmalines

Very Beautiful And High Lustre

1.30 Cts
5 x 4.4 x 3.7mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 179, 1, 'loose_stone', 'Tourmaline', NULL, 1.3, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/277e3b31-6b7e-462b-ae98-e9220ac1b0e9/etsy-1.jpg","https://media.gemworkers.com/items/277e3b31-6b7e-462b-ae98-e9220ac1b0e9/etsy-2.jpg","https://media.gemworkers.com/items/277e3b31-6b7e-462b-ae98-e9220ac1b0e9/etsy-3.jpg","https://media.gemworkers.com/items/277e3b31-6b7e-462b-ae98-e9220ac1b0e9/etsy-4.jpg","https://media.gemworkers.com/items/277e3b31-6b7e-462b-ae98-e9220ac1b0e9/etsy-5.jpg","https://media.gemworkers.com/items/277e3b31-6b7e-462b-ae98-e9220ac1b0e9/etsy-6.jpg","https://media.gemworkers.com/items/277e3b31-6b7e-462b-ae98-e9220ac1b0e9/etsy-7.jpg","https://media.gemworkers.com/items/277e3b31-6b7e-462b-ae98-e9220ac1b0e9/etsy-8.jpg","https://media.gemworkers.com/items/277e3b31-6b7e-462b-ae98-e9220ac1b0e9/etsy-9.jpg","https://media.gemworkers.com/items/277e3b31-6b7e-462b-ae98-e9220ac1b0e9/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 200 USD, converted at ECB rate. Etsy tags: Jewellery Supplies,Gift For Her,Natural Stone,Silver Sterling,Gold Ring,Tourmaline Jewellery,y2k earrings stud,Seafoam Tourmaline,Mint Tourmaline,Blue Tourmaline,Jewels,lagoon tourmaline,Oceangemsminerals.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('5ed66cc5-3784-4f58-8cb4-a82e4d5e20b7', '1.25 Cts Lagoon Colour Tourmaline', 'Presenting One Of The Best Colour In Tourmalines

Exceptional Colour Very Rare To Be Find, Bright Colour Not Dull.

More Beautiful In Real. eye Clean

1.25 Cts
9 x 5.5 x 4.3mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 179, 1, 'loose_stone', 'Tourmaline', NULL, 1.25, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/5ed66cc5-3784-4f58-8cb4-a82e4d5e20b7/etsy-1.jpg","https://media.gemworkers.com/items/5ed66cc5-3784-4f58-8cb4-a82e4d5e20b7/etsy-2.jpg","https://media.gemworkers.com/items/5ed66cc5-3784-4f58-8cb4-a82e4d5e20b7/etsy-3.jpg","https://media.gemworkers.com/items/5ed66cc5-3784-4f58-8cb4-a82e4d5e20b7/etsy-4.jpg","https://media.gemworkers.com/items/5ed66cc5-3784-4f58-8cb4-a82e4d5e20b7/etsy-5.jpg","https://media.gemworkers.com/items/5ed66cc5-3784-4f58-8cb4-a82e4d5e20b7/etsy-6.jpg","https://media.gemworkers.com/items/5ed66cc5-3784-4f58-8cb4-a82e4d5e20b7/etsy-7.jpg","https://media.gemworkers.com/items/5ed66cc5-3784-4f58-8cb4-a82e4d5e20b7/etsy-8.jpg","https://media.gemworkers.com/items/5ed66cc5-3784-4f58-8cb4-a82e4d5e20b7/etsy-9.jpg","https://media.gemworkers.com/items/5ed66cc5-3784-4f58-8cb4-a82e4d5e20b7/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 200 USD, converted at ECB rate. Etsy tags: Paraiba Tourmaline,Paraiba Colour,Lagoon Tourmaline,Bluegreen Tourmaline,Blue Tourmaline,Neon Blue Tourmaline,Tourmaline Jewellery,Jewellers,Lagoon Colour,Oceangemsminerals,Ink Blue Tourmaline,Wedding Rings,Rings For Women.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('f32bfdea-e2a9-49f0-a816-11b2f3e8c7da', '1.65 Cts Ink Blue Tourmaline', 'Top Colour Ink Blue Colour Tourmaline Emerald Cut 

rare find

1.65 Cts
8.1 x 5.4 x 4.4mm

No Treatment Whatsoever.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 107, 1, 'loose_stone', 'Tourmaline', NULL, 1.65, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/f32bfdea-e2a9-49f0-a816-11b2f3e8c7da/etsy-1.jpg","https://media.gemworkers.com/items/f32bfdea-e2a9-49f0-a816-11b2f3e8c7da/etsy-2.jpg","https://media.gemworkers.com/items/f32bfdea-e2a9-49f0-a816-11b2f3e8c7da/etsy-3.jpg","https://media.gemworkers.com/items/f32bfdea-e2a9-49f0-a816-11b2f3e8c7da/etsy-4.jpg","https://media.gemworkers.com/items/f32bfdea-e2a9-49f0-a816-11b2f3e8c7da/etsy-5.jpg","https://media.gemworkers.com/items/f32bfdea-e2a9-49f0-a816-11b2f3e8c7da/etsy-6.jpg","https://media.gemworkers.com/items/f32bfdea-e2a9-49f0-a816-11b2f3e8c7da/etsy-7.jpg","https://media.gemworkers.com/items/f32bfdea-e2a9-49f0-a816-11b2f3e8c7da/etsy-8.jpg","https://media.gemworkers.com/items/f32bfdea-e2a9-49f0-a816-11b2f3e8c7da/etsy-9.jpg","https://media.gemworkers.com/items/f32bfdea-e2a9-49f0-a816-11b2f3e8c7da/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 120 USD, converted at ECB rate. Etsy tags: Emerald Cut,EmeraldCutTourmaline,Jewellery making,earrings stud,Tourmaline Lot,Blue Tourmaline,Lagoon Tourmaline,Neon Blue,neon blue tourmaline,Rings For Men,Tourmalines,Ink Blue Tourmaline,Oceangemsminerals.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('537496a4-5d02-4b36-9499-6184a99b3163', '1.80 Cts Blue Bicolour Tourmaline', 'Bicolour Blue Mesmerising Afghan Tourmaline 

1.80 Cts
11.3 x 4.8 x 3.8mm

glowing 

unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 116, 1, 'loose_stone', 'Tourmaline', NULL, 1.8, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/537496a4-5d02-4b36-9499-6184a99b3163/etsy-1.jpg","https://media.gemworkers.com/items/537496a4-5d02-4b36-9499-6184a99b3163/etsy-2.jpg","https://media.gemworkers.com/items/537496a4-5d02-4b36-9499-6184a99b3163/etsy-3.jpg","https://media.gemworkers.com/items/537496a4-5d02-4b36-9499-6184a99b3163/etsy-4.jpg","https://media.gemworkers.com/items/537496a4-5d02-4b36-9499-6184a99b3163/etsy-5.jpg","https://media.gemworkers.com/items/537496a4-5d02-4b36-9499-6184a99b3163/etsy-6.jpg","https://media.gemworkers.com/items/537496a4-5d02-4b36-9499-6184a99b3163/etsy-7.jpg","https://media.gemworkers.com/items/537496a4-5d02-4b36-9499-6184a99b3163/etsy-8.jpg","https://media.gemworkers.com/items/537496a4-5d02-4b36-9499-6184a99b3163/etsy-9.jpg","https://media.gemworkers.com/items/537496a4-5d02-4b36-9499-6184a99b3163/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 130 USD, converted at ECB rate. Etsy tags: Bicolour Tourmaline,Blue Tourmaline,Lagoon Tourmaline,Neon Tourmaline,Tourmaline jewellery,gift for her,natural stone,Tourmaline Rings,tourmaline necklace,rings for men,rings for women,jewellery making,jewellery supplies.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('eb5aff11-8d0f-4564-9761-81cf219abf88', '1.1 Cts Rubilite Tourmaline', 'Gorgeous Rubilite Tourmaline best for ring 💍 

1.10 Cts
6.2 x 6.2 x 4.8mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 161, 1, 'loose_stone', 'Tourmaline', 'Rubellite', 1.1, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/eb5aff11-8d0f-4564-9761-81cf219abf88/etsy-1.jpg","https://media.gemworkers.com/items/eb5aff11-8d0f-4564-9761-81cf219abf88/etsy-2.jpg","https://media.gemworkers.com/items/eb5aff11-8d0f-4564-9761-81cf219abf88/etsy-3.jpg","https://media.gemworkers.com/items/eb5aff11-8d0f-4564-9761-81cf219abf88/etsy-4.jpg","https://media.gemworkers.com/items/eb5aff11-8d0f-4564-9761-81cf219abf88/etsy-5.jpg","https://media.gemworkers.com/items/eb5aff11-8d0f-4564-9761-81cf219abf88/etsy-6.jpg","https://media.gemworkers.com/items/eb5aff11-8d0f-4564-9761-81cf219abf88/etsy-7.jpg","https://media.gemworkers.com/items/eb5aff11-8d0f-4564-9761-81cf219abf88/etsy-8.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 180 USD, converted at ECB rate. Etsy tags: Red Rubilite,PigeonBlood Rubilite,Orange Rubilite,Pinkish Rubilite,Red Tourmaline,Pink Tourmaline,Orange Tourmaline,Cushion Cut,Tourmaline Jewellery,Tourmaline Faceted,Rubilite Tourmaline,Jewellery Making,Jewellery Findings.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('ef210565-172d-4ae9-a824-9549e88d36a9', '1.75 Cts Blue bicolour tourmaline', 'Unique Seafoam Bicolour Tourmalines

high lustre 

1.75 Cts
9 x 5.2 x 3.9mm

no treatment.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 170, 1, 'loose_stone', 'Tourmaline', NULL, 1.75, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/ef210565-172d-4ae9-a824-9549e88d36a9/etsy-1.jpg","https://media.gemworkers.com/items/ef210565-172d-4ae9-a824-9549e88d36a9/etsy-2.jpg","https://media.gemworkers.com/items/ef210565-172d-4ae9-a824-9549e88d36a9/etsy-3.jpg","https://media.gemworkers.com/items/ef210565-172d-4ae9-a824-9549e88d36a9/etsy-4.jpg","https://media.gemworkers.com/items/ef210565-172d-4ae9-a824-9549e88d36a9/etsy-5.jpg","https://media.gemworkers.com/items/ef210565-172d-4ae9-a824-9549e88d36a9/etsy-6.jpg","https://media.gemworkers.com/items/ef210565-172d-4ae9-a824-9549e88d36a9/etsy-7.jpg","https://media.gemworkers.com/items/ef210565-172d-4ae9-a824-9549e88d36a9/etsy-8.jpg","https://media.gemworkers.com/items/ef210565-172d-4ae9-a824-9549e88d36a9/etsy-9.jpg","https://media.gemworkers.com/items/ef210565-172d-4ae9-a824-9549e88d36a9/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 190 USD, converted at ECB rate. Etsy tags: Blue Bicolour,Bicolour Tourmaline,Blue Tourmaline,Lavender Tourmaline,Purple Tourmaline,Lagoon tourmaline,neon blue tourmaline,jewellery making,gift for her,Natural stone,Handmadejewellery,Seafoam Tourmaline,Unique Tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('496e45ea-f574-40e1-9441-466e45c89415', '1.95 Cts Blue Bicolour Tourmaline', 'Bicolour Blue Mesmerising Afghan Tourmaline 

1.95 Cts
11.6 x 4.8 x 3.8mm

glowing 

unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 107, 1, 'loose_stone', 'Tourmaline', NULL, 1.95, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/496e45ea-f574-40e1-9441-466e45c89415/etsy-1.jpg","https://media.gemworkers.com/items/496e45ea-f574-40e1-9441-466e45c89415/etsy-2.jpg","https://media.gemworkers.com/items/496e45ea-f574-40e1-9441-466e45c89415/etsy-3.jpg","https://media.gemworkers.com/items/496e45ea-f574-40e1-9441-466e45c89415/etsy-4.jpg","https://media.gemworkers.com/items/496e45ea-f574-40e1-9441-466e45c89415/etsy-5.jpg","https://media.gemworkers.com/items/496e45ea-f574-40e1-9441-466e45c89415/etsy-6.jpg","https://media.gemworkers.com/items/496e45ea-f574-40e1-9441-466e45c89415/etsy-7.jpg","https://media.gemworkers.com/items/496e45ea-f574-40e1-9441-466e45c89415/etsy-8.jpg","https://media.gemworkers.com/items/496e45ea-f574-40e1-9441-466e45c89415/etsy-9.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 120 USD, converted at ECB rate. Etsy tags: Bicolour Tourmaline,Blue Tourmaline,Lagoon Tourmaline,Neon Tourmaline,Tourmaline jewellery,gift for her,natural stone,Tourmaline Rings,tourmaline necklace,rings for men,rings for women,jewellery making,jewellery supplies.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('0bf9188a-c30b-4e9e-8f76-cf32ee8f9eed', '1.55 Cts, Pink Tourmaline', 'Pink colour tourmaline 

natural Afghanistan 

Unique Colour And High Lustre 

Slightly Included 

1.55 Cts
8.3 x 5.2 x 4.2mm

no treatment', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 134, 1, 'loose_stone', 'Tourmaline', NULL, 1.55, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/0bf9188a-c30b-4e9e-8f76-cf32ee8f9eed/etsy-1.jpg","https://media.gemworkers.com/items/0bf9188a-c30b-4e9e-8f76-cf32ee8f9eed/etsy-2.jpg","https://media.gemworkers.com/items/0bf9188a-c30b-4e9e-8f76-cf32ee8f9eed/etsy-3.jpg","https://media.gemworkers.com/items/0bf9188a-c30b-4e9e-8f76-cf32ee8f9eed/etsy-4.jpg","https://media.gemworkers.com/items/0bf9188a-c30b-4e9e-8f76-cf32ee8f9eed/etsy-5.jpg","https://media.gemworkers.com/items/0bf9188a-c30b-4e9e-8f76-cf32ee8f9eed/etsy-6.jpg","https://media.gemworkers.com/items/0bf9188a-c30b-4e9e-8f76-cf32ee8f9eed/etsy-7.jpg","https://media.gemworkers.com/items/0bf9188a-c30b-4e9e-8f76-cf32ee8f9eed/etsy-8.jpg","https://media.gemworkers.com/items/0bf9188a-c30b-4e9e-8f76-cf32ee8f9eed/etsy-9.jpg","https://media.gemworkers.com/items/0bf9188a-c30b-4e9e-8f76-cf32ee8f9eed/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 150 USD, converted at ECB rate. Etsy tags: pink tourmaline,peachpink tourmaline,bicolour tourmaline,afghan tourmaline,cushion cut,jewellery making,jewellery supplies,jewellery findings,gift for her,natural stone,rings for women,Handmadejewellery,lavender tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('bede98ca-51f9-4c84-8bc6-a18ffd9eef05', '4.40 Cts Rubilite Tourmaline', 'Gorgeous Rubilite Tourmaline best for ring 💍 

4.40 Cts
12.5 x 10 x 5mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 107, 1, 'loose_stone', 'Tourmaline', 'Rubellite', 4.4, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/bede98ca-51f9-4c84-8bc6-a18ffd9eef05/etsy-1.jpg","https://media.gemworkers.com/items/bede98ca-51f9-4c84-8bc6-a18ffd9eef05/etsy-2.jpg","https://media.gemworkers.com/items/bede98ca-51f9-4c84-8bc6-a18ffd9eef05/etsy-3.jpg","https://media.gemworkers.com/items/bede98ca-51f9-4c84-8bc6-a18ffd9eef05/etsy-4.jpg","https://media.gemworkers.com/items/bede98ca-51f9-4c84-8bc6-a18ffd9eef05/etsy-5.jpg","https://media.gemworkers.com/items/bede98ca-51f9-4c84-8bc6-a18ffd9eef05/etsy-6.jpg","https://media.gemworkers.com/items/bede98ca-51f9-4c84-8bc6-a18ffd9eef05/etsy-7.jpg","https://media.gemworkers.com/items/bede98ca-51f9-4c84-8bc6-a18ffd9eef05/etsy-8.jpg","https://media.gemworkers.com/items/bede98ca-51f9-4c84-8bc6-a18ffd9eef05/etsy-9.jpg","https://media.gemworkers.com/items/bede98ca-51f9-4c84-8bc6-a18ffd9eef05/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 120 USD, converted at ECB rate. Etsy tags: Red Rubilite,PigeonBlood Rubilite,Orange Rubilite,Pinkish Rubilite,Red Tourmaline,Pink Tourmaline,Orange Tourmaline,Cushion Cut,Tourmaline Jewellery,Tourmaline Faceted,Rubilite Tourmaline,Jewellery Making,Jewellery Findings.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('18616d54-3e9e-4d10-ba99-a57fbb0bff0d', '1.75 Cts lagoon Colour Tourmaline', 'Top Quality Lagoon Colour Tourmaline

rare find

1.75 Cts
7 x 6.8 x 4.7mm

No Treatment Whatsoever.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 179, 1, 'loose_stone', 'Tourmaline', NULL, 1.75, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/18616d54-3e9e-4d10-ba99-a57fbb0bff0d/etsy-1.jpg","https://media.gemworkers.com/items/18616d54-3e9e-4d10-ba99-a57fbb0bff0d/etsy-2.jpg","https://media.gemworkers.com/items/18616d54-3e9e-4d10-ba99-a57fbb0bff0d/etsy-3.jpg","https://media.gemworkers.com/items/18616d54-3e9e-4d10-ba99-a57fbb0bff0d/etsy-4.jpg","https://media.gemworkers.com/items/18616d54-3e9e-4d10-ba99-a57fbb0bff0d/etsy-5.jpg","https://media.gemworkers.com/items/18616d54-3e9e-4d10-ba99-a57fbb0bff0d/etsy-6.jpg","https://media.gemworkers.com/items/18616d54-3e9e-4d10-ba99-a57fbb0bff0d/etsy-7.jpg","https://media.gemworkers.com/items/18616d54-3e9e-4d10-ba99-a57fbb0bff0d/etsy-8.jpg","https://media.gemworkers.com/items/18616d54-3e9e-4d10-ba99-a57fbb0bff0d/etsy-9.jpg","https://media.gemworkers.com/items/18616d54-3e9e-4d10-ba99-a57fbb0bff0d/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 200 USD, converted at ECB rate. Etsy tags: Emerald Cut,EmeraldCutTourmaline,Jewellery making,earrings stud,Tourmaline Lot,Blue Tourmaline,Lagoon Tourmaline,Neon Blue,neon blue tourmaline,Rings For Men,Tourmalines,Ink Blue Tourmaline,Oceangemsminerals.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('04d6f067-3fe7-4ca5-96fe-f1515001ba69', '23 Cts Huge Green Tourmaline', 'Big Size Green Colour Tourmaline 

Truly A Collection Piece, You Can Use It in a Necklace 

Inclusions Gives It Special Characteristics 

23 Cts
16.4 x 15 x 11.2mm

Looks Like A 40 Cts Stone

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 1607, 1, 'loose_stone', 'Tourmaline', NULL, 23, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/04d6f067-3fe7-4ca5-96fe-f1515001ba69/etsy-1.jpg","https://media.gemworkers.com/items/04d6f067-3fe7-4ca5-96fe-f1515001ba69/etsy-2.jpg","https://media.gemworkers.com/items/04d6f067-3fe7-4ca5-96fe-f1515001ba69/etsy-3.jpg","https://media.gemworkers.com/items/04d6f067-3fe7-4ca5-96fe-f1515001ba69/etsy-4.jpg","https://media.gemworkers.com/items/04d6f067-3fe7-4ca5-96fe-f1515001ba69/etsy-5.jpg","https://media.gemworkers.com/items/04d6f067-3fe7-4ca5-96fe-f1515001ba69/etsy-6.jpg","https://media.gemworkers.com/items/04d6f067-3fe7-4ca5-96fe-f1515001ba69/etsy-7.jpg","https://media.gemworkers.com/items/04d6f067-3fe7-4ca5-96fe-f1515001ba69/etsy-8.jpg","https://media.gemworkers.com/items/04d6f067-3fe7-4ca5-96fe-f1515001ba69/etsy-9.jpg","https://media.gemworkers.com/items/04d6f067-3fe7-4ca5-96fe-f1515001ba69/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 1799 USD, converted at ECB rate. Etsy tags: Green Tourmaline,Collection Piece,CollectionTourmaline,Big Tourmaline,Necklace Jewellery,Tourmaline Necklace,Faceted Tourmaline,Emerald Cut,Lagoon Tourmaline,Tourmaline Crystals,Tourmaline Specimen,Oceangemsminerals,Uniquegemstyle.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('27ff19a8-3f57-4832-843d-1b23e9890d7c', 'Royal Earrings: 6.50 Cts Ink Blue Tourmaline', 'Gorgeous Mesmerising Rare Ink Blue Colour Afghan Tourmaline Pairs

Open Colour,

6.50 Cts

4.20 Cts ( 11.9 x 5.5 x 3.4mm)
2.70 Cts ( 7.4 x 5.4 x 3.5mm )

unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 407, 1, 'jewelry', 'Tourmaline', NULL, 6.5, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/27ff19a8-3f57-4832-843d-1b23e9890d7c/etsy-1.jpg","https://media.gemworkers.com/items/27ff19a8-3f57-4832-843d-1b23e9890d7c/etsy-2.jpg","https://media.gemworkers.com/items/27ff19a8-3f57-4832-843d-1b23e9890d7c/etsy-3.jpg","https://media.gemworkers.com/items/27ff19a8-3f57-4832-843d-1b23e9890d7c/etsy-4.jpg","https://media.gemworkers.com/items/27ff19a8-3f57-4832-843d-1b23e9890d7c/etsy-5.jpg","https://media.gemworkers.com/items/27ff19a8-3f57-4832-843d-1b23e9890d7c/etsy-6.jpg","https://media.gemworkers.com/items/27ff19a8-3f57-4832-843d-1b23e9890d7c/etsy-7.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 455 USD, converted at ECB rate. Etsy tags: Rings For Men,Rings For Women,Tourmaline Jewellery,Natural Stone,bicolour Tourmaline,Lagoon tourmaline,Bluegreen tourmaline,blue tourmaline,indigo tourmaline,Oceangemsminerals,rare tourmaline,ink blue tourmaline,Unique Tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('f8940563-469c-49b4-b61b-662364b1b074', '1 Cts Neon Blue Tourmaline', 'lagoon and neon blue colour tourmaline

top colour high lustre and brilliance 

Paraiba Like Colour

1 Cts
5.6 x 5.4 x 4.4mm

100% natural no treatment whatsoever.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 357, 1, 'loose_stone', 'Tourmaline', NULL, 1, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/f8940563-469c-49b4-b61b-662364b1b074/etsy-1.jpg","https://media.gemworkers.com/items/f8940563-469c-49b4-b61b-662364b1b074/etsy-2.jpg","https://media.gemworkers.com/items/f8940563-469c-49b4-b61b-662364b1b074/etsy-3.jpg","https://media.gemworkers.com/items/f8940563-469c-49b4-b61b-662364b1b074/etsy-4.jpg","https://media.gemworkers.com/items/f8940563-469c-49b4-b61b-662364b1b074/etsy-5.jpg","https://media.gemworkers.com/items/f8940563-469c-49b4-b61b-662364b1b074/etsy-6.jpg","https://media.gemworkers.com/items/f8940563-469c-49b4-b61b-662364b1b074/etsy-7.jpg","https://media.gemworkers.com/items/f8940563-469c-49b4-b61b-662364b1b074/etsy-8.jpg","https://media.gemworkers.com/items/f8940563-469c-49b4-b61b-662364b1b074/etsy-9.jpg","https://media.gemworkers.com/items/f8940563-469c-49b4-b61b-662364b1b074/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 400 USD, converted at ECB rate. Etsy tags: Natural Stone,Jewellery Supplies,Jewellery Making,Jewellery Findings,y2k stud earrings,Gift For Her,Rings For Men,Rings For Women,Gold Rings,Silver Sterling,Garnet Necklace,Garnet Rings,Garnet Jewellery.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('54838918-ca78-4c84-b669-a7d879bdd253', '10.7 Cts Lagoon Tourmaline Lot', 'Gorgeous Top Lagoon Colour Tourmaline Lot

Exceptional Colour Very Rare To Be Find, Bright Colour Not Dull.

More Beautiful In Real.

10.70 Cts
5.8 to 7.2mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 625, 1, 'loose_stone', 'Tourmaline', NULL, 10.7, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/54838918-ca78-4c84-b669-a7d879bdd253/etsy-1.jpg","https://media.gemworkers.com/items/54838918-ca78-4c84-b669-a7d879bdd253/etsy-2.jpg","https://media.gemworkers.com/items/54838918-ca78-4c84-b669-a7d879bdd253/etsy-3.jpg","https://media.gemworkers.com/items/54838918-ca78-4c84-b669-a7d879bdd253/etsy-4.jpg","https://media.gemworkers.com/items/54838918-ca78-4c84-b669-a7d879bdd253/etsy-5.jpg","https://media.gemworkers.com/items/54838918-ca78-4c84-b669-a7d879bdd253/etsy-6.jpg","https://media.gemworkers.com/items/54838918-ca78-4c84-b669-a7d879bdd253/etsy-7.jpg","https://media.gemworkers.com/items/54838918-ca78-4c84-b669-a7d879bdd253/etsy-8.jpg","https://media.gemworkers.com/items/54838918-ca78-4c84-b669-a7d879bdd253/etsy-9.jpg","https://media.gemworkers.com/items/54838918-ca78-4c84-b669-a7d879bdd253/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 700 USD, converted at ECB rate. Etsy tags: Paraiba Tourmaline,Paraiba Colour,Lagoon Tourmaline,Bluegreen Tourmaline,Blue Tourmaline,Neon Blue Tourmaline,Tourmaline Jewellery,Jewellers,Lagoon Colour,Oceangemsminerals,Ink Blue Tourmaline,Wedding Rings,Rings For Women.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('7e53049f-bce2-4011-9a3d-f231fad38099', '4.45 Cts, Deep Blue Tourmaline Pair', 'Gorgeous Deep Blue Mesmerising Afghan Tourmaline 

Unique And Rare 

4.45 Cts
18 x 2.5 x 2mm
10.7 x 2.8 x 2.3mm

glowing 

unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 223, 1, 'loose_stone', 'Tourmaline', NULL, 4.45, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/7e53049f-bce2-4011-9a3d-f231fad38099/etsy-1.jpg","https://media.gemworkers.com/items/7e53049f-bce2-4011-9a3d-f231fad38099/etsy-2.jpg","https://media.gemworkers.com/items/7e53049f-bce2-4011-9a3d-f231fad38099/etsy-3.jpg","https://media.gemworkers.com/items/7e53049f-bce2-4011-9a3d-f231fad38099/etsy-4.jpg","https://media.gemworkers.com/items/7e53049f-bce2-4011-9a3d-f231fad38099/etsy-5.jpg","https://media.gemworkers.com/items/7e53049f-bce2-4011-9a3d-f231fad38099/etsy-6.jpg","https://media.gemworkers.com/items/7e53049f-bce2-4011-9a3d-f231fad38099/etsy-7.jpg","https://media.gemworkers.com/items/7e53049f-bce2-4011-9a3d-f231fad38099/etsy-8.jpg","https://media.gemworkers.com/items/7e53049f-bce2-4011-9a3d-f231fad38099/etsy-9.jpg","https://media.gemworkers.com/items/7e53049f-bce2-4011-9a3d-f231fad38099/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 250 USD, converted at ECB rate. Etsy tags: Bicolour Tourmaline,Blue Tourmaline,Lagoon Tourmaline,Neon Tourmaline,Tourmaline jewellery,gift for her,natural stone,Tourmaline Rings,tourmaline necklace,rings for men,rings for women,Oceangemsminerals,tourmaline pairs.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('73649c66-91a2-40c6-b8a3-a56b0a82e1b9', '3.8 Cts, Deep Blue Tourmaline Pair', 'Gorgeous Deep Blue Mesmerising Afghan Tourmaline 

Unique And Rare 

3.80 Cts
15.8 x 2.8 x 2.2mm
15.4 x 2.6 x 2.2mm

glowing 

unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 197, 1, 'loose_stone', 'Tourmaline', NULL, 3.8, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/73649c66-91a2-40c6-b8a3-a56b0a82e1b9/etsy-1.jpg","https://media.gemworkers.com/items/73649c66-91a2-40c6-b8a3-a56b0a82e1b9/etsy-2.jpg","https://media.gemworkers.com/items/73649c66-91a2-40c6-b8a3-a56b0a82e1b9/etsy-3.jpg","https://media.gemworkers.com/items/73649c66-91a2-40c6-b8a3-a56b0a82e1b9/etsy-4.jpg","https://media.gemworkers.com/items/73649c66-91a2-40c6-b8a3-a56b0a82e1b9/etsy-5.jpg","https://media.gemworkers.com/items/73649c66-91a2-40c6-b8a3-a56b0a82e1b9/etsy-6.jpg","https://media.gemworkers.com/items/73649c66-91a2-40c6-b8a3-a56b0a82e1b9/etsy-7.jpg","https://media.gemworkers.com/items/73649c66-91a2-40c6-b8a3-a56b0a82e1b9/etsy-8.jpg","https://media.gemworkers.com/items/73649c66-91a2-40c6-b8a3-a56b0a82e1b9/etsy-9.jpg","https://media.gemworkers.com/items/73649c66-91a2-40c6-b8a3-a56b0a82e1b9/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 220 USD, converted at ECB rate. Etsy tags: Bicolour Tourmaline,Blue Tourmaline,Lagoon Tourmaline,Neon Tourmaline,Tourmaline jewellery,gift for her,natural stone,Tourmaline Rings,tourmaline necklace,rings for men,rings for women,Oceangemsminerals,tourmaline pairs.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('ccc668e8-7f0b-4ebe-9d58-590446583017', '12.5 Cts Deep Blue Tourmaline lot', 'Gorgeous Deep Blue Mesmerising Afghan Tourmaline lot

Unique And Rare 

12.50 cts
7.9mm to 18.9mm

glowing 

unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 223, 1, 'loose_stone', 'Tourmaline', NULL, 12.5, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/ccc668e8-7f0b-4ebe-9d58-590446583017/etsy-1.jpg","https://media.gemworkers.com/items/ccc668e8-7f0b-4ebe-9d58-590446583017/etsy-2.jpg","https://media.gemworkers.com/items/ccc668e8-7f0b-4ebe-9d58-590446583017/etsy-3.jpg","https://media.gemworkers.com/items/ccc668e8-7f0b-4ebe-9d58-590446583017/etsy-4.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 250 USD, converted at ECB rate. Etsy tags: Bicolour Tourmaline,Blue Tourmaline,Lagoon Tourmaline,Neon Tourmaline,Tourmaline jewellery,gift for her,natural stone,Tourmaline Rings,tourmaline necklace,rings for men,rings for women,Oceangemsminerals,tourmaline pairs.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('0dc65d8e-b546-4ed6-89d9-2be6c54ebb14', '11.7 Cts Green Tourmaline Lot', 'Step Cushion Cut Afghan Green Tourmalines

11.70 Cts
5.5 to 14mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 179, 1, 'loose_stone', 'Tourmaline', NULL, 11.7, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/0dc65d8e-b546-4ed6-89d9-2be6c54ebb14/etsy-1.jpg","https://media.gemworkers.com/items/0dc65d8e-b546-4ed6-89d9-2be6c54ebb14/etsy-2.jpg","https://media.gemworkers.com/items/0dc65d8e-b546-4ed6-89d9-2be6c54ebb14/etsy-3.jpg","https://media.gemworkers.com/items/0dc65d8e-b546-4ed6-89d9-2be6c54ebb14/etsy-4.jpg","https://media.gemworkers.com/items/0dc65d8e-b546-4ed6-89d9-2be6c54ebb14/etsy-5.jpg","https://media.gemworkers.com/items/0dc65d8e-b546-4ed6-89d9-2be6c54ebb14/etsy-6.jpg","https://media.gemworkers.com/items/0dc65d8e-b546-4ed6-89d9-2be6c54ebb14/etsy-7.jpg","https://media.gemworkers.com/items/0dc65d8e-b546-4ed6-89d9-2be6c54ebb14/etsy-8.jpg","https://media.gemworkers.com/items/0dc65d8e-b546-4ed6-89d9-2be6c54ebb14/etsy-9.jpg","https://media.gemworkers.com/items/0dc65d8e-b546-4ed6-89d9-2be6c54ebb14/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 200 USD, converted at ECB rate. Etsy tags: Paraiba Tourmaline,Paraiba Colour,Lagoon Tourmaline,Bluegreen Tourmaline,Blue Tourmaline,Neon Blue Tourmaline,Tourmaline Jewellery,Lagoon Colour,Oceangemsminerals,Ink Blue Tourmaline,Wedding Rings,Rings For Women,Cushion Cut.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('1aaefceb-e1be-4df0-84cc-e9d8a11f142f', '16.3 Cts Green Tourmaline Lot', 'Step Cushion Cut Afghan Green Tourmalines

16.30 Cts
6 to 8.2mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 447, 1, 'loose_stone', 'Tourmaline', NULL, 16.3, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/1aaefceb-e1be-4df0-84cc-e9d8a11f142f/etsy-1.jpg","https://media.gemworkers.com/items/1aaefceb-e1be-4df0-84cc-e9d8a11f142f/etsy-2.jpg","https://media.gemworkers.com/items/1aaefceb-e1be-4df0-84cc-e9d8a11f142f/etsy-3.jpg","https://media.gemworkers.com/items/1aaefceb-e1be-4df0-84cc-e9d8a11f142f/etsy-4.jpg","https://media.gemworkers.com/items/1aaefceb-e1be-4df0-84cc-e9d8a11f142f/etsy-5.jpg","https://media.gemworkers.com/items/1aaefceb-e1be-4df0-84cc-e9d8a11f142f/etsy-6.jpg","https://media.gemworkers.com/items/1aaefceb-e1be-4df0-84cc-e9d8a11f142f/etsy-7.jpg","https://media.gemworkers.com/items/1aaefceb-e1be-4df0-84cc-e9d8a11f142f/etsy-8.jpg","https://media.gemworkers.com/items/1aaefceb-e1be-4df0-84cc-e9d8a11f142f/etsy-9.jpg","https://media.gemworkers.com/items/1aaefceb-e1be-4df0-84cc-e9d8a11f142f/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 500 USD, converted at ECB rate. Etsy tags: Paraiba Tourmaline,Paraiba Colour,Lagoon Tourmaline,Bluegreen Tourmaline,Blue Tourmaline,Neon Blue Tourmaline,Tourmaline Jewellery,Lagoon Colour,Oceangemsminerals,Ink Blue Tourmaline,Wedding Rings,Rings For Women,Cushion Cut.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('bc8e473b-6a2f-4ac2-8a1e-fb3f7c184edd', '7.2 Cts Lagoon Tourmaline Lot', 'Lagoon Afghan Tourmaline Lot 

Cushion Cut.

High Lustre And Good Colours.

7.2 Cts
6.3 to 7.7mm

Unheated,Untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 357, 1, 'loose_stone', 'Tourmaline', NULL, 7.2, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/bc8e473b-6a2f-4ac2-8a1e-fb3f7c184edd/etsy-1.jpg","https://media.gemworkers.com/items/bc8e473b-6a2f-4ac2-8a1e-fb3f7c184edd/etsy-2.jpg","https://media.gemworkers.com/items/bc8e473b-6a2f-4ac2-8a1e-fb3f7c184edd/etsy-3.jpg","https://media.gemworkers.com/items/bc8e473b-6a2f-4ac2-8a1e-fb3f7c184edd/etsy-4.jpg","https://media.gemworkers.com/items/bc8e473b-6a2f-4ac2-8a1e-fb3f7c184edd/etsy-5.jpg","https://media.gemworkers.com/items/bc8e473b-6a2f-4ac2-8a1e-fb3f7c184edd/etsy-6.jpg","https://media.gemworkers.com/items/bc8e473b-6a2f-4ac2-8a1e-fb3f7c184edd/etsy-7.jpg","https://media.gemworkers.com/items/bc8e473b-6a2f-4ac2-8a1e-fb3f7c184edd/etsy-8.jpg","https://media.gemworkers.com/items/bc8e473b-6a2f-4ac2-8a1e-fb3f7c184edd/etsy-9.jpg","https://media.gemworkers.com/items/bc8e473b-6a2f-4ac2-8a1e-fb3f7c184edd/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 400 USD, converted at ECB rate. Etsy tags: Jewellery Making,Jewellery Supplies,Gemstones Jewellery,Jewellery Findings,Gift for her,Rings For Women,Rings For Men,Gold Rings,Jewels,Bluegreen tourmaline,neon tourmaline,lagoon tourmaline,mintgreentourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('c0dd3423-5a67-4c00-8cbf-dd33ffc258f3', '2.15 Cts Vibrant Green Tourmaline', 'Beautiful Top Green Afghan Tourmaline

Vibrant Colour

Perfectly Cut

2.15 Cts
7.4 x 6.3 x 5.5mm

Unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 357, 1, 'loose_stone', 'Tourmaline', NULL, 2.15, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/c0dd3423-5a67-4c00-8cbf-dd33ffc258f3/etsy-1.jpg","https://media.gemworkers.com/items/c0dd3423-5a67-4c00-8cbf-dd33ffc258f3/etsy-2.jpg","https://media.gemworkers.com/items/c0dd3423-5a67-4c00-8cbf-dd33ffc258f3/etsy-3.jpg","https://media.gemworkers.com/items/c0dd3423-5a67-4c00-8cbf-dd33ffc258f3/etsy-4.jpg","https://media.gemworkers.com/items/c0dd3423-5a67-4c00-8cbf-dd33ffc258f3/etsy-5.jpg","https://media.gemworkers.com/items/c0dd3423-5a67-4c00-8cbf-dd33ffc258f3/etsy-6.jpg","https://media.gemworkers.com/items/c0dd3423-5a67-4c00-8cbf-dd33ffc258f3/etsy-7.jpg","https://media.gemworkers.com/items/c0dd3423-5a67-4c00-8cbf-dd33ffc258f3/etsy-8.jpg","https://media.gemworkers.com/items/c0dd3423-5a67-4c00-8cbf-dd33ffc258f3/etsy-9.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 400 USD, converted at ECB rate. Etsy tags: Green Tourmaline,Vibrant Tourmaline,AppleGreenTourmaline,Tourmaline jewellery,jewellers,jewellery making,jewellery supplies,jewellery findings,Oceangemsminerals,rings for women,rings for men,rings jewellery,natural stone.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('aefae917-0333-4a32-805b-3c4ab77d6924', '3.10 Cts Olive Tourmaline Pair', 'Cool Olive Green Colour Tourmaline Pair

3.10 Cts
6.7 x 6.1 x 5mm

no treatment, unheated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 223, 1, 'loose_stone', 'Tourmaline', NULL, 3.1, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/aefae917-0333-4a32-805b-3c4ab77d6924/etsy-1.jpg","https://media.gemworkers.com/items/aefae917-0333-4a32-805b-3c4ab77d6924/etsy-2.jpg","https://media.gemworkers.com/items/aefae917-0333-4a32-805b-3c4ab77d6924/etsy-3.jpg","https://media.gemworkers.com/items/aefae917-0333-4a32-805b-3c4ab77d6924/etsy-4.jpg","https://media.gemworkers.com/items/aefae917-0333-4a32-805b-3c4ab77d6924/etsy-5.jpg","https://media.gemworkers.com/items/aefae917-0333-4a32-805b-3c4ab77d6924/etsy-6.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 250 USD, converted at ECB rate. Etsy tags: Jewellery Making,Jewellery Supplies,Jewellery Findings,Earrings Findings,y2k earrings Stud,Stud jewellery,Natural Stone,Blue Tourmaline Pair,Gift For Her,Unique Pair,olive tourmaline,green tourmaline,olive green.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('3f169021-6f3e-4792-8937-906db8270f05', 'Watermelon Tourmaline Gemstones: Rare Color, High Lustre, Sugar Inclusions (5 Cts)', 'Sweet Perfect Watermelon Tourmaline 

Unique And Rare Colour

Very Shiny And High Lustre

Sugar Inclusions Gives It More Beauty 

5 Cts
11.8 to 12.8mm

No treatment.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 357, 1, 'loose_stone', 'Tourmaline', 'Watermelon', 5, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/3f169021-6f3e-4792-8937-906db8270f05/etsy-1.jpg","https://media.gemworkers.com/items/3f169021-6f3e-4792-8937-906db8270f05/etsy-2.jpg","https://media.gemworkers.com/items/3f169021-6f3e-4792-8937-906db8270f05/etsy-3.jpg","https://media.gemworkers.com/items/3f169021-6f3e-4792-8937-906db8270f05/etsy-4.jpg","https://media.gemworkers.com/items/3f169021-6f3e-4792-8937-906db8270f05/etsy-5.jpg","https://media.gemworkers.com/items/3f169021-6f3e-4792-8937-906db8270f05/etsy-6.jpg","https://media.gemworkers.com/items/3f169021-6f3e-4792-8937-906db8270f05/etsy-7.jpg","https://media.gemworkers.com/items/3f169021-6f3e-4792-8937-906db8270f05/etsy-8.jpg","https://media.gemworkers.com/items/3f169021-6f3e-4792-8937-906db8270f05/etsy-9.jpg","https://media.gemworkers.com/items/3f169021-6f3e-4792-8937-906db8270f05/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 400 USD, converted at ECB rate. Etsy tags: Tourmaline Jewellery,Tourmaline Earrings,Earrings Stud,y2k earrings stud,Gold Rings,Natural Stone,Gift For Her,Rings For Men,Oceangemsminerals,lagoon tourmaline,tourmaline pairs,bicolour tourmaline,Watermelon Bicolour.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('a0954e15-18d6-4d47-8721-e0e184514016', '1.40 Cts Baby Pink Tourmaline', 'mesmerising baby pink tourmaline 

Top Quality Fineest Colour

1.40 Cts
6.1 x 5.9 x 4.9mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 179, 1, 'loose_stone', 'Tourmaline', NULL, 1.4, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/a0954e15-18d6-4d47-8721-e0e184514016/etsy-1.jpg","https://media.gemworkers.com/items/a0954e15-18d6-4d47-8721-e0e184514016/etsy-2.jpg","https://media.gemworkers.com/items/a0954e15-18d6-4d47-8721-e0e184514016/etsy-3.jpg","https://media.gemworkers.com/items/a0954e15-18d6-4d47-8721-e0e184514016/etsy-4.jpg","https://media.gemworkers.com/items/a0954e15-18d6-4d47-8721-e0e184514016/etsy-5.jpg","https://media.gemworkers.com/items/a0954e15-18d6-4d47-8721-e0e184514016/etsy-6.jpg","https://media.gemworkers.com/items/a0954e15-18d6-4d47-8721-e0e184514016/etsy-7.jpg","https://media.gemworkers.com/items/a0954e15-18d6-4d47-8721-e0e184514016/etsy-8.jpg","https://media.gemworkers.com/items/a0954e15-18d6-4d47-8721-e0e184514016/etsy-9.jpg","https://media.gemworkers.com/items/a0954e15-18d6-4d47-8721-e0e184514016/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 200 USD, converted at ECB rate. Etsy tags: Emerald Cut,Bicolour Tourmaline,Tricolour Tourmaline,Pink Bicolour,Unheated,Tourmaline jewellery,Natural Stone,Gift For Her,Blue tourmalines,Green Tourmaline,Rings For Men,Gold Rings,Stud Jewellery.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('73a81500-4161-44b6-a2ed-24df51fc28f9', '3.30 Cts Bicolour Tourmaline', 'Gorgeous Mesmerising Bicolour Blue And Green Natural Afghanistan Tourmaline 

More beautiful In real, One of a kind

3.30 Cts
10.6 x 6.9 x 4.9mm

unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 357, 1, 'loose_stone', 'Tourmaline', NULL, 3.3, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/73a81500-4161-44b6-a2ed-24df51fc28f9/etsy-1.jpg","https://media.gemworkers.com/items/73a81500-4161-44b6-a2ed-24df51fc28f9/etsy-2.jpg","https://media.gemworkers.com/items/73a81500-4161-44b6-a2ed-24df51fc28f9/etsy-3.jpg","https://media.gemworkers.com/items/73a81500-4161-44b6-a2ed-24df51fc28f9/etsy-4.jpg","https://media.gemworkers.com/items/73a81500-4161-44b6-a2ed-24df51fc28f9/etsy-5.jpg","https://media.gemworkers.com/items/73a81500-4161-44b6-a2ed-24df51fc28f9/etsy-6.jpg","https://media.gemworkers.com/items/73a81500-4161-44b6-a2ed-24df51fc28f9/etsy-7.jpg","https://media.gemworkers.com/items/73a81500-4161-44b6-a2ed-24df51fc28f9/etsy-8.jpg","https://media.gemworkers.com/items/73a81500-4161-44b6-a2ed-24df51fc28f9/etsy-9.jpg","https://media.gemworkers.com/items/73a81500-4161-44b6-a2ed-24df51fc28f9/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 400 USD, converted at ECB rate. Etsy tags: Gold Rings,Rings For Men,Tourmaline Jewellery,Natural Stone,bicolour Tourmaline,Lagoon tourmaline,Bluegreen tourmaline,blue tourmaline,indicolite tourmalin,tourmaline rings,faceted tourmaline,Oceangemsminerals,tourmaline lot.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('0ab5a959-cbe2-42b8-ba67-ddf209983846', 'Watermelon Tourmaline Gemstones: Rare Color, High Lustre, Sugar Inclusions (7.70 Cts)', 'Sweet Perfect Watermelon Tourmaline 

Unique And Rare Colour

Very Shiny And High Lustre

Sugar Inclusions Gives It More Beauty 

7.70 Cts
14.7 x 8.8 x 6.4mm

No treatment.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 804, 1, 'loose_stone', 'Tourmaline', 'Watermelon', 7.7, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/0ab5a959-cbe2-42b8-ba67-ddf209983846/etsy-1.jpg","https://media.gemworkers.com/items/0ab5a959-cbe2-42b8-ba67-ddf209983846/etsy-2.jpg","https://media.gemworkers.com/items/0ab5a959-cbe2-42b8-ba67-ddf209983846/etsy-3.jpg","https://media.gemworkers.com/items/0ab5a959-cbe2-42b8-ba67-ddf209983846/etsy-4.jpg","https://media.gemworkers.com/items/0ab5a959-cbe2-42b8-ba67-ddf209983846/etsy-5.jpg","https://media.gemworkers.com/items/0ab5a959-cbe2-42b8-ba67-ddf209983846/etsy-6.jpg","https://media.gemworkers.com/items/0ab5a959-cbe2-42b8-ba67-ddf209983846/etsy-7.jpg","https://media.gemworkers.com/items/0ab5a959-cbe2-42b8-ba67-ddf209983846/etsy-8.jpg","https://media.gemworkers.com/items/0ab5a959-cbe2-42b8-ba67-ddf209983846/etsy-9.jpg","https://media.gemworkers.com/items/0ab5a959-cbe2-42b8-ba67-ddf209983846/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 900 USD, converted at ECB rate. Etsy tags: Tourmaline Jewellery,Tourmaline Earrings,Earrings Stud,y2k earrings stud,Gold Rings,Natural Stone,Gift For Her,Rings For Men,Oceangemsminerals,lagoon tourmaline,tourmaline pairs,bicolour tourmaline,Watermelon Bicolour.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('9f539602-5168-4822-a978-709d10237b74', 'Watermelon Tourmaline Gemstones: Rare Color, High Lustre, Sugar Inclusions (5.65 Cts)', 'Sweet Perfect Watermelon Tourmaline 

Unique And Rare Colour

Very Shiny And High Lustre

Sugar Inclusions Gives It More Beauty 

5.65 Cts
11.6 x 8.6 x 6.4mm

No treatment.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 429, 1, 'loose_stone', 'Tourmaline', 'Watermelon', 5.65, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/9f539602-5168-4822-a978-709d10237b74/etsy-1.jpg","https://media.gemworkers.com/items/9f539602-5168-4822-a978-709d10237b74/etsy-2.jpg","https://media.gemworkers.com/items/9f539602-5168-4822-a978-709d10237b74/etsy-3.jpg","https://media.gemworkers.com/items/9f539602-5168-4822-a978-709d10237b74/etsy-4.jpg","https://media.gemworkers.com/items/9f539602-5168-4822-a978-709d10237b74/etsy-5.jpg","https://media.gemworkers.com/items/9f539602-5168-4822-a978-709d10237b74/etsy-6.jpg","https://media.gemworkers.com/items/9f539602-5168-4822-a978-709d10237b74/etsy-7.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 480 USD, converted at ECB rate. Etsy tags: Tourmaline Jewellery,Tourmaline Earrings,Earrings Stud,y2k earrings stud,Gold Rings,Natural Stone,Gift For Her,Rings For Men,Oceangemsminerals,lagoon tourmaline,tourmaline pairs,bicolour tourmaline,Watermelon Bicolour.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('9b3e2cd3-2d8e-406f-9a4d-399bf3df026a', 'Watermelon Tourmaline Gemstones: Rare Color, High Lustre, Sugar Inclusions (8.15 Cts)', 'Sweet Perfect Watermelon Tourmaline 

Unique And Rare Colour

Very Shiny And High Lustre

Sugar Inclusions Gives It More Beauty 

8.15 Cts
12.9 x 8.9 x 7.8mm

No treatment.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 447, 1, 'loose_stone', 'Tourmaline', 'Watermelon', 8.15, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/9b3e2cd3-2d8e-406f-9a4d-399bf3df026a/etsy-1.jpg","https://media.gemworkers.com/items/9b3e2cd3-2d8e-406f-9a4d-399bf3df026a/etsy-2.jpg","https://media.gemworkers.com/items/9b3e2cd3-2d8e-406f-9a4d-399bf3df026a/etsy-3.jpg","https://media.gemworkers.com/items/9b3e2cd3-2d8e-406f-9a4d-399bf3df026a/etsy-4.jpg","https://media.gemworkers.com/items/9b3e2cd3-2d8e-406f-9a4d-399bf3df026a/etsy-5.jpg","https://media.gemworkers.com/items/9b3e2cd3-2d8e-406f-9a4d-399bf3df026a/etsy-6.jpg","https://media.gemworkers.com/items/9b3e2cd3-2d8e-406f-9a4d-399bf3df026a/etsy-7.jpg","https://media.gemworkers.com/items/9b3e2cd3-2d8e-406f-9a4d-399bf3df026a/etsy-8.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 500 USD, converted at ECB rate. Etsy tags: Tourmaline Jewellery,Tourmaline Earrings,Earrings Stud,y2k earrings stud,Gold Rings,Natural Stone,Gift For Her,Rings For Men,Oceangemsminerals,lagoon tourmaline,tourmaline pairs,bicolour tourmaline,Watermelon Bicolour.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('93d349b2-8564-43ba-beac-6b130a1dbedd', '1.80 Cts Pink Tourmaline Pair', 'Gorgeous Pink Tourmaline Pair Fancy Cut

Loupe Clean

1.80 Cts
5.8 x 5.4 x 4.5mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 268, 1, 'loose_stone', 'Tourmaline', NULL, 1.8, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/93d349b2-8564-43ba-beac-6b130a1dbedd/etsy-1.jpg","https://media.gemworkers.com/items/93d349b2-8564-43ba-beac-6b130a1dbedd/etsy-2.jpg","https://media.gemworkers.com/items/93d349b2-8564-43ba-beac-6b130a1dbedd/etsy-3.jpg","https://media.gemworkers.com/items/93d349b2-8564-43ba-beac-6b130a1dbedd/etsy-4.jpg","https://media.gemworkers.com/items/93d349b2-8564-43ba-beac-6b130a1dbedd/etsy-5.jpg","https://media.gemworkers.com/items/93d349b2-8564-43ba-beac-6b130a1dbedd/etsy-6.jpg","https://media.gemworkers.com/items/93d349b2-8564-43ba-beac-6b130a1dbedd/etsy-7.jpg","https://media.gemworkers.com/items/93d349b2-8564-43ba-beac-6b130a1dbedd/etsy-8.jpg","https://media.gemworkers.com/items/93d349b2-8564-43ba-beac-6b130a1dbedd/etsy-9.jpg","https://media.gemworkers.com/items/93d349b2-8564-43ba-beac-6b130a1dbedd/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 300 USD, converted at ECB rate. Etsy tags: pink tourmaline,rings for women,unique tourmaline,jewels,Handmadejewellery,gift for her,Topqualitytourmaline,Bicolour Tourmaline,Unique Bicolour,Rare Tourmaline,Oceangemsminerals,Tourmaline Pairs,Bicolour Pairs.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('433de856-cde3-4885-936a-826161e2768a', '19.35 Cts Yellow Natural Kunzite', 'Gorgeous Yellow Natural Kunzite 

19.35 Cts
18 x 11.5 x 10.1mm

high lustre

unique and rare colour', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 179, 1, 'loose_stone', 'Kunzite', NULL, 19.35, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/433de856-cde3-4885-936a-826161e2768a/etsy-1.jpg","https://media.gemworkers.com/items/433de856-cde3-4885-936a-826161e2768a/etsy-2.jpg","https://media.gemworkers.com/items/433de856-cde3-4885-936a-826161e2768a/etsy-3.jpg","https://media.gemworkers.com/items/433de856-cde3-4885-936a-826161e2768a/etsy-4.jpg","https://media.gemworkers.com/items/433de856-cde3-4885-936a-826161e2768a/etsy-5.jpg","https://media.gemworkers.com/items/433de856-cde3-4885-936a-826161e2768a/etsy-6.jpg","https://media.gemworkers.com/items/433de856-cde3-4885-936a-826161e2768a/etsy-7.jpg","https://media.gemworkers.com/items/433de856-cde3-4885-936a-826161e2768a/etsy-8.jpg","https://media.gemworkers.com/items/433de856-cde3-4885-936a-826161e2768a/etsy-9.jpg","https://media.gemworkers.com/items/433de856-cde3-4885-936a-826161e2768a/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 200 USD, converted at ECB rate. Etsy tags: Terminated Crystals,Jewellery Making,Aquamarine Specimen,Collectors,AquamarineCollection,Blue Aquamarine,Green Aquamarine,Gift For Her,Natural Stone,Kunzite Crystal,Heated Kunzite,Rough Kunzite,Kunzite Jewellery.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('3ae5978f-569f-4820-80b6-cd4868ba9805', '2.7 Cts Bicolour Tourmalinee', 'Gorgeous Mesmerising Bicolour Green Natural Afghanistan Tourmaline 

More beautiful In real, One of a kind

2.7 Cts
17.3 x 4.2 x 3.3mm

unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 268, 1, 'loose_stone', 'Tourmaline', NULL, 2.7, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/3ae5978f-569f-4820-80b6-cd4868ba9805/etsy-1.jpg","https://media.gemworkers.com/items/3ae5978f-569f-4820-80b6-cd4868ba9805/etsy-2.jpg","https://media.gemworkers.com/items/3ae5978f-569f-4820-80b6-cd4868ba9805/etsy-3.jpg","https://media.gemworkers.com/items/3ae5978f-569f-4820-80b6-cd4868ba9805/etsy-4.jpg","https://media.gemworkers.com/items/3ae5978f-569f-4820-80b6-cd4868ba9805/etsy-5.jpg","https://media.gemworkers.com/items/3ae5978f-569f-4820-80b6-cd4868ba9805/etsy-6.jpg","https://media.gemworkers.com/items/3ae5978f-569f-4820-80b6-cd4868ba9805/etsy-7.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 300 USD, converted at ECB rate. Etsy tags: Gold Rings,Rings For Men,Tourmaline Jewellery,Natural Stone,bicolour Tourmaline,Lagoon tourmaline,Bluegreen tourmaline,blue tourmaline,indicolite tourmalin,tourmaline rings,faceted tourmaline,Oceangemsminerals,tourmaline lot.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('8ff2d8ef-2508-42c9-afc6-7da5178f267f', '3 Cts Watermelon Bicolour Tourmaline', 'Top Quality Natural Watermelon Bicolour Tourmaline Emerald Cut 

Rare find, High Lustre, Top Polish

Glowing And Sweet Stone

3 Cts
15.3 x 5 x 3.8mm

No Treatment Whatsoever.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 268, 1, 'loose_stone', 'Tourmaline', 'Watermelon', 3, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/8ff2d8ef-2508-42c9-afc6-7da5178f267f/etsy-1.jpg","https://media.gemworkers.com/items/8ff2d8ef-2508-42c9-afc6-7da5178f267f/etsy-2.jpg","https://media.gemworkers.com/items/8ff2d8ef-2508-42c9-afc6-7da5178f267f/etsy-3.jpg","https://media.gemworkers.com/items/8ff2d8ef-2508-42c9-afc6-7da5178f267f/etsy-4.jpg","https://media.gemworkers.com/items/8ff2d8ef-2508-42c9-afc6-7da5178f267f/etsy-5.jpg","https://media.gemworkers.com/items/8ff2d8ef-2508-42c9-afc6-7da5178f267f/etsy-6.jpg","https://media.gemworkers.com/items/8ff2d8ef-2508-42c9-afc6-7da5178f267f/etsy-7.jpg","https://media.gemworkers.com/items/8ff2d8ef-2508-42c9-afc6-7da5178f267f/etsy-8.jpg","https://media.gemworkers.com/items/8ff2d8ef-2508-42c9-afc6-7da5178f267f/etsy-9.jpg","https://media.gemworkers.com/items/8ff2d8ef-2508-42c9-afc6-7da5178f267f/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 300 USD, converted at ECB rate. Etsy tags: Emerald Cut,EmeraldCutTourmaline,Jewellery making,earrings stud,Tourmaline Lot,Blue Tourmaline,Lagoon Tourmaline,Neon Blue,neon blue tourmaline,Rings For Men,Tourmalines,Ink Blue Tourmaline,Oceangemsminerals.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('279fec6b-f759-4938-952b-14e7efcfe065', '8.30 Cts blue and Green Tourmaline Lot', 'Blue and Green Afghan Tourmaline Lot 

High Lustre And Good Colours.

8.30 Cts
9.6 to 6.4mm

Unheated,Untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 161, 1, 'loose_stone', 'Tourmaline', NULL, 8.3, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/279fec6b-f759-4938-952b-14e7efcfe065/etsy-1.jpg","https://media.gemworkers.com/items/279fec6b-f759-4938-952b-14e7efcfe065/etsy-2.jpg","https://media.gemworkers.com/items/279fec6b-f759-4938-952b-14e7efcfe065/etsy-3.jpg","https://media.gemworkers.com/items/279fec6b-f759-4938-952b-14e7efcfe065/etsy-4.jpg","https://media.gemworkers.com/items/279fec6b-f759-4938-952b-14e7efcfe065/etsy-5.jpg","https://media.gemworkers.com/items/279fec6b-f759-4938-952b-14e7efcfe065/etsy-6.jpg","https://media.gemworkers.com/items/279fec6b-f759-4938-952b-14e7efcfe065/etsy-7.jpg","https://media.gemworkers.com/items/279fec6b-f759-4938-952b-14e7efcfe065/etsy-8.jpg","https://media.gemworkers.com/items/279fec6b-f759-4938-952b-14e7efcfe065/etsy-9.jpg","https://media.gemworkers.com/items/279fec6b-f759-4938-952b-14e7efcfe065/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 180 USD, converted at ECB rate. Etsy tags: Jewellery Making,Jewellery Supplies,Gemstones Jewellery,Jewellery Findings,Gift for her,Rings For Women,Rings For Men,Gold Rings,Jewels,Bluegreen tourmaline,neon tourmaline,lagoon tourmaline,mintgreentourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('af7c100e-27bb-4667-b993-da83f75e85a3', '13.35 Cts Bicolour Tourmaline Lot', 'Gorgeous Bicolour Tourmaline Lot

Best For Jewellery 

13.35 Cts
5.8 to 4.6mm

no treatment whatsoever', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 179, 1, 'loose_stone', 'Tourmaline', NULL, 13.35, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/af7c100e-27bb-4667-b993-da83f75e85a3/etsy-1.jpg","https://media.gemworkers.com/items/af7c100e-27bb-4667-b993-da83f75e85a3/etsy-2.jpg","https://media.gemworkers.com/items/af7c100e-27bb-4667-b993-da83f75e85a3/etsy-3.jpg","https://media.gemworkers.com/items/af7c100e-27bb-4667-b993-da83f75e85a3/etsy-4.jpg","https://media.gemworkers.com/items/af7c100e-27bb-4667-b993-da83f75e85a3/etsy-5.jpg","https://media.gemworkers.com/items/af7c100e-27bb-4667-b993-da83f75e85a3/etsy-6.jpg","https://media.gemworkers.com/items/af7c100e-27bb-4667-b993-da83f75e85a3/etsy-7.jpg","https://media.gemworkers.com/items/af7c100e-27bb-4667-b993-da83f75e85a3/etsy-8.jpg","https://media.gemworkers.com/items/af7c100e-27bb-4667-b993-da83f75e85a3/etsy-9.jpg","https://media.gemworkers.com/items/af7c100e-27bb-4667-b993-da83f75e85a3/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 200 USD, converted at ECB rate. Etsy tags: Tourmaline Jewellery,Tourmaline Rings,Natural Stone,Bicolour Tourmaline,Loose gemstones,Gold Rings,Rings For women,Rings For Men,y2k earrings stud,bicolour stone,Oceangemsminerals,Tricolour Tourmaline,Tourmaline Pairs.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('fc210cba-1742-4fc9-a539-5f3fbf10f1ce', '17.80 Cts Rare Bicolour Tourmaline Lot', 'Gorgeous Unique Bicolour and Tricolour Tourmaline Lot

high lustre, Saturated Colour.

17.80 Cts
9.8 to 8mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 268, 1, 'loose_stone', 'Tourmaline', NULL, 17.8, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/fc210cba-1742-4fc9-a539-5f3fbf10f1ce/etsy-1.jpg","https://media.gemworkers.com/items/fc210cba-1742-4fc9-a539-5f3fbf10f1ce/etsy-2.jpg","https://media.gemworkers.com/items/fc210cba-1742-4fc9-a539-5f3fbf10f1ce/etsy-3.jpg","https://media.gemworkers.com/items/fc210cba-1742-4fc9-a539-5f3fbf10f1ce/etsy-4.jpg","https://media.gemworkers.com/items/fc210cba-1742-4fc9-a539-5f3fbf10f1ce/etsy-5.jpg","https://media.gemworkers.com/items/fc210cba-1742-4fc9-a539-5f3fbf10f1ce/etsy-6.jpg","https://media.gemworkers.com/items/fc210cba-1742-4fc9-a539-5f3fbf10f1ce/etsy-7.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 300 USD, converted at ECB rate. Etsy tags: Tourmaline Rings,rings for women,rings for men,jewellery making,jewellery findings,gift for her,natural stone,Oceangemsminerals,apple green colour,Bicolour Tourmaline,Natural Bicolour,Unheated Tourmaline,Lipstick Tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('4b8db1c7-f275-4cbe-bcfb-98ed155b0806', '12.15 Cts Rare Bicolour Tourmaline Lot', 'Gorgeous Mesmerising Natural Watermelon With Rainbow Colour Stripes Bicolour Afghan Tourmaline Lot

high lustre, Saturated Colour.

12.15 Cts 
8.2 to 4.7mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 268, 1, 'loose_stone', 'Tourmaline', NULL, 12.15, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/4b8db1c7-f275-4cbe-bcfb-98ed155b0806/etsy-1.jpg","https://media.gemworkers.com/items/4b8db1c7-f275-4cbe-bcfb-98ed155b0806/etsy-2.jpg","https://media.gemworkers.com/items/4b8db1c7-f275-4cbe-bcfb-98ed155b0806/etsy-3.jpg","https://media.gemworkers.com/items/4b8db1c7-f275-4cbe-bcfb-98ed155b0806/etsy-4.jpg","https://media.gemworkers.com/items/4b8db1c7-f275-4cbe-bcfb-98ed155b0806/etsy-5.jpg","https://media.gemworkers.com/items/4b8db1c7-f275-4cbe-bcfb-98ed155b0806/etsy-6.jpg","https://media.gemworkers.com/items/4b8db1c7-f275-4cbe-bcfb-98ed155b0806/etsy-7.jpg","https://media.gemworkers.com/items/4b8db1c7-f275-4cbe-bcfb-98ed155b0806/etsy-8.jpg","https://media.gemworkers.com/items/4b8db1c7-f275-4cbe-bcfb-98ed155b0806/etsy-9.jpg","https://media.gemworkers.com/items/4b8db1c7-f275-4cbe-bcfb-98ed155b0806/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 300 USD, converted at ECB rate. Etsy tags: Tourmaline Rings,rings for women,rings for men,jewellery making,jewellery findings,gift for her,natural stone,Oceangemsminerals,apple green colour,Bicolour Tourmaline,Natural Bicolour,Unheated Tourmaline,Lipstick Tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('15082014-901b-400d-8f4c-00a3f01b9ec7', '14.50 Cts Rare Bicolour Tourmaline Lot', 'Gorgeous Unique Bicolour and Tricolour Tourmaline Lot

high lustre, Saturated Colour.

14.50 Cts
7.5 to 6.2mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 179, 1, 'loose_stone', 'Tourmaline', NULL, 14.5, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/15082014-901b-400d-8f4c-00a3f01b9ec7/etsy-1.jpg","https://media.gemworkers.com/items/15082014-901b-400d-8f4c-00a3f01b9ec7/etsy-2.jpg","https://media.gemworkers.com/items/15082014-901b-400d-8f4c-00a3f01b9ec7/etsy-3.jpg","https://media.gemworkers.com/items/15082014-901b-400d-8f4c-00a3f01b9ec7/etsy-4.jpg","https://media.gemworkers.com/items/15082014-901b-400d-8f4c-00a3f01b9ec7/etsy-5.jpg","https://media.gemworkers.com/items/15082014-901b-400d-8f4c-00a3f01b9ec7/etsy-6.jpg","https://media.gemworkers.com/items/15082014-901b-400d-8f4c-00a3f01b9ec7/etsy-7.jpg","https://media.gemworkers.com/items/15082014-901b-400d-8f4c-00a3f01b9ec7/etsy-8.jpg","https://media.gemworkers.com/items/15082014-901b-400d-8f4c-00a3f01b9ec7/etsy-9.jpg","https://media.gemworkers.com/items/15082014-901b-400d-8f4c-00a3f01b9ec7/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 200 USD, converted at ECB rate. Etsy tags: Tourmaline Rings,rings for women,rings for men,jewellery making,jewellery findings,gift for her,natural stone,Oceangemsminerals,apple green colour,Bicolour Tourmaline,Natural Bicolour,Unheated Tourmaline,Lipstick Tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('5b168b6a-573e-4378-8383-c082668e0ce7', '19.50 Cts Rare Tourmaline Lot', 'Gorgeous Mesmerising Natural Watermelon With Rainbow Colour Stripes Bicolour Afghan Tourmaline Lot

high lustre, Saturated Colour.

19.50 Cts
8.6 to 6.6mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 357, 1, 'loose_stone', 'Tourmaline', NULL, 19.5, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/5b168b6a-573e-4378-8383-c082668e0ce7/etsy-1.jpg","https://media.gemworkers.com/items/5b168b6a-573e-4378-8383-c082668e0ce7/etsy-2.jpg","https://media.gemworkers.com/items/5b168b6a-573e-4378-8383-c082668e0ce7/etsy-3.jpg","https://media.gemworkers.com/items/5b168b6a-573e-4378-8383-c082668e0ce7/etsy-4.jpg","https://media.gemworkers.com/items/5b168b6a-573e-4378-8383-c082668e0ce7/etsy-5.jpg","https://media.gemworkers.com/items/5b168b6a-573e-4378-8383-c082668e0ce7/etsy-6.jpg","https://media.gemworkers.com/items/5b168b6a-573e-4378-8383-c082668e0ce7/etsy-7.jpg","https://media.gemworkers.com/items/5b168b6a-573e-4378-8383-c082668e0ce7/etsy-8.jpg","https://media.gemworkers.com/items/5b168b6a-573e-4378-8383-c082668e0ce7/etsy-9.jpg","https://media.gemworkers.com/items/5b168b6a-573e-4378-8383-c082668e0ce7/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 400 USD, converted at ECB rate. Etsy tags: Tourmaline Rings,rings for women,rings for men,jewellery making,jewellery findings,gift for her,natural stone,Oceangemsminerals,apple green colour,Bicolour Tourmaline,Natural Bicolour,Unheated Tourmaline,Lipstick Tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('76b6400d-895d-4231-a12c-0c593484cd0c', '16.50 Cts Bicolour Tourmaline Lot', 'Gorgeous Bicolour Tourmaline Lot

Best For Jewellery 

16.50 Cts
6.8 to 5.2mm

no treatment whatsoever', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 179, 1, 'loose_stone', 'Tourmaline', NULL, 16.5, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/76b6400d-895d-4231-a12c-0c593484cd0c/etsy-1.jpg","https://media.gemworkers.com/items/76b6400d-895d-4231-a12c-0c593484cd0c/etsy-2.jpg","https://media.gemworkers.com/items/76b6400d-895d-4231-a12c-0c593484cd0c/etsy-3.jpg","https://media.gemworkers.com/items/76b6400d-895d-4231-a12c-0c593484cd0c/etsy-4.jpg","https://media.gemworkers.com/items/76b6400d-895d-4231-a12c-0c593484cd0c/etsy-5.jpg","https://media.gemworkers.com/items/76b6400d-895d-4231-a12c-0c593484cd0c/etsy-6.jpg","https://media.gemworkers.com/items/76b6400d-895d-4231-a12c-0c593484cd0c/etsy-7.jpg","https://media.gemworkers.com/items/76b6400d-895d-4231-a12c-0c593484cd0c/etsy-8.jpg","https://media.gemworkers.com/items/76b6400d-895d-4231-a12c-0c593484cd0c/etsy-9.jpg","https://media.gemworkers.com/items/76b6400d-895d-4231-a12c-0c593484cd0c/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 200 USD, converted at ECB rate. Etsy tags: Tourmaline Jewellery,Tourmaline Rings,Natural Stone,Bicolour Tourmaline,Loose gemstones,Gold Rings,Rings For women,Rings For Men,y2k earrings stud,bicolour stone,Oceangemsminerals,Tricolour Tourmaline,Tourmaline Pairs.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('34639aef-34e4-46a5-b252-12c231a14af1', '3.60 Cts Rare Tourmaline Pair', 'Gorgeous Mesmerising Natural Watermelon With Rainbow Colour Stripes Bicolour Afghan Tourmaline pair

high lustre, Saturated Colour.

3.65 Cts
8.1 x 5.8 x 3.8mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 357, 1, 'loose_stone', 'Tourmaline', NULL, 3.6, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/34639aef-34e4-46a5-b252-12c231a14af1/etsy-1.jpg","https://media.gemworkers.com/items/34639aef-34e4-46a5-b252-12c231a14af1/etsy-2.jpg","https://media.gemworkers.com/items/34639aef-34e4-46a5-b252-12c231a14af1/etsy-3.jpg","https://media.gemworkers.com/items/34639aef-34e4-46a5-b252-12c231a14af1/etsy-4.jpg","https://media.gemworkers.com/items/34639aef-34e4-46a5-b252-12c231a14af1/etsy-5.jpg","https://media.gemworkers.com/items/34639aef-34e4-46a5-b252-12c231a14af1/etsy-6.jpg","https://media.gemworkers.com/items/34639aef-34e4-46a5-b252-12c231a14af1/etsy-7.jpg","https://media.gemworkers.com/items/34639aef-34e4-46a5-b252-12c231a14af1/etsy-8.jpg","https://media.gemworkers.com/items/34639aef-34e4-46a5-b252-12c231a14af1/etsy-9.jpg","https://media.gemworkers.com/items/34639aef-34e4-46a5-b252-12c231a14af1/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 400 USD, converted at ECB rate. Etsy tags: Tourmaline Rings,rings for women,rings for men,jewellery making,jewellery findings,gift for her,natural stone,Oceangemsminerals,apple green colour,Bicolour Tourmaline,Natural Bicolour,Unheated Tourmaline,Lipstick Tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('1dcb649f-1235-42d6-b84b-5c79d5150674', '26 Cts Bicolour Tourmaline Rosecuts lot', 'Gorgeous Bicolour Tourmaline Rosecuts Lot

 Nice Polished

26 Cts
4.5 to 13mm

unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 125, 1, 'loose_stone', 'Tourmaline', NULL, 26, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/1dcb649f-1235-42d6-b84b-5c79d5150674/etsy-1.jpg","https://media.gemworkers.com/items/1dcb649f-1235-42d6-b84b-5c79d5150674/etsy-2.jpg","https://media.gemworkers.com/items/1dcb649f-1235-42d6-b84b-5c79d5150674/etsy-3.jpg","https://media.gemworkers.com/items/1dcb649f-1235-42d6-b84b-5c79d5150674/etsy-4.jpg","https://media.gemworkers.com/items/1dcb649f-1235-42d6-b84b-5c79d5150674/etsy-5.jpg","https://media.gemworkers.com/items/1dcb649f-1235-42d6-b84b-5c79d5150674/etsy-6.jpg","https://media.gemworkers.com/items/1dcb649f-1235-42d6-b84b-5c79d5150674/etsy-7.jpg","https://media.gemworkers.com/items/1dcb649f-1235-42d6-b84b-5c79d5150674/etsy-8.jpg","https://media.gemworkers.com/items/1dcb649f-1235-42d6-b84b-5c79d5150674/etsy-9.jpg","https://media.gemworkers.com/items/1dcb649f-1235-42d6-b84b-5c79d5150674/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 140 USD, converted at ECB rate. Etsy tags: Santa Maria Cabochon,Unique Aquamarine,Bicolour Aquamarine,Bicolour Cabochons,Blue Cabochons,Lagoon Cabochons,Natural Stone,jewels,Oceangemsminerals,Tourmaline Rosecuts,Lagoon Rosecuts,Blue Tourmaline,Blue Rosecuts.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('ab2c7e04-d522-4d24-a60b-af318aabd42d', '7.65 Cts Tourmaline Lot', 'Gorgeous Bicolour Unique Natural Afghanistan Tourmaline

7.65 Cts
6.2 to 9.5mm

Unheated, Untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 205, 1, 'loose_stone', 'Tourmaline', NULL, 7.65, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/ab2c7e04-d522-4d24-a60b-af318aabd42d/etsy-1.jpg","https://media.gemworkers.com/items/ab2c7e04-d522-4d24-a60b-af318aabd42d/etsy-2.jpg","https://media.gemworkers.com/items/ab2c7e04-d522-4d24-a60b-af318aabd42d/etsy-3.jpg","https://media.gemworkers.com/items/ab2c7e04-d522-4d24-a60b-af318aabd42d/etsy-4.jpg","https://media.gemworkers.com/items/ab2c7e04-d522-4d24-a60b-af318aabd42d/etsy-5.jpg","https://media.gemworkers.com/items/ab2c7e04-d522-4d24-a60b-af318aabd42d/etsy-6.jpg","https://media.gemworkers.com/items/ab2c7e04-d522-4d24-a60b-af318aabd42d/etsy-7.jpg","https://media.gemworkers.com/items/ab2c7e04-d522-4d24-a60b-af318aabd42d/etsy-8.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 230 USD, converted at ECB rate. Etsy tags: Blue Tourmaline,Tourmaline Lot,Bicolour Tourmaline,Tricolour Tourmaline,Blue Cap Tourmaline,Faceted Tourmaline,Oceangemsminerals,jewellery making,jewellery findings,jewellery supplies,gift for her,natural stone,Natural Tourmalines.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('3e162d66-1428-47ff-b3e2-c46b5ed196d8', 'Unique Bicolour Tourmaline,2.90 Cts', 'Rare Multi Colour Tourmaline 

2.90 Cts
11.5 x 6.5 x 4.5mm

no heat, no treatment.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 80, 1, 'loose_stone', 'Tourmaline', NULL, 2.9, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/3e162d66-1428-47ff-b3e2-c46b5ed196d8/etsy-1.jpg","https://media.gemworkers.com/items/3e162d66-1428-47ff-b3e2-c46b5ed196d8/etsy-2.jpg","https://media.gemworkers.com/items/3e162d66-1428-47ff-b3e2-c46b5ed196d8/etsy-3.jpg","https://media.gemworkers.com/items/3e162d66-1428-47ff-b3e2-c46b5ed196d8/etsy-4.jpg","https://media.gemworkers.com/items/3e162d66-1428-47ff-b3e2-c46b5ed196d8/etsy-5.jpg","https://media.gemworkers.com/items/3e162d66-1428-47ff-b3e2-c46b5ed196d8/etsy-6.jpg","https://media.gemworkers.com/items/3e162d66-1428-47ff-b3e2-c46b5ed196d8/etsy-7.jpg","https://media.gemworkers.com/items/3e162d66-1428-47ff-b3e2-c46b5ed196d8/etsy-8.jpg","https://media.gemworkers.com/items/3e162d66-1428-47ff-b3e2-c46b5ed196d8/etsy-9.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 90 USD, converted at ECB rate. Etsy tags: Bicolour Tourmaline,Blue and pink,Tourmaline set,Tourmaline pairs,Lagoon tourmaline,Neon blue tourmaline,Earrings set,Jewellery making,Jewellery supplies,Jewellery findings,Gift for her,Handmadejewellery,Natural stone.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('6df0e054-cd2f-438c-bad3-cea559a23476', '7.40 Cts Rainbow Bicolour Tourmaline', 'Multi Colour Rainbow Inside Tourmaline 

Exceptional And Rare

7.40 Cts
22.1 x 7 x 4.5mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 357, 1, 'loose_stone', 'Tourmaline', NULL, 7.4, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/6df0e054-cd2f-438c-bad3-cea559a23476/etsy-1.jpg","https://media.gemworkers.com/items/6df0e054-cd2f-438c-bad3-cea559a23476/etsy-2.jpg","https://media.gemworkers.com/items/6df0e054-cd2f-438c-bad3-cea559a23476/etsy-3.jpg","https://media.gemworkers.com/items/6df0e054-cd2f-438c-bad3-cea559a23476/etsy-4.jpg","https://media.gemworkers.com/items/6df0e054-cd2f-438c-bad3-cea559a23476/etsy-5.jpg","https://media.gemworkers.com/items/6df0e054-cd2f-438c-bad3-cea559a23476/etsy-6.jpg","https://media.gemworkers.com/items/6df0e054-cd2f-438c-bad3-cea559a23476/etsy-7.jpg","https://media.gemworkers.com/items/6df0e054-cd2f-438c-bad3-cea559a23476/etsy-8.jpg","https://media.gemworkers.com/items/6df0e054-cd2f-438c-bad3-cea559a23476/etsy-9.jpg","https://media.gemworkers.com/items/6df0e054-cd2f-438c-bad3-cea559a23476/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 400 USD, converted at ECB rate. Etsy tags: pink tourmaline,rings for women,unique tourmaline,jewels,Handmadejewellery,gift for her,Topqualitytourmaline,Bicolour Tourmaline,Unique Bicolour,Rare Tourmaline,Oceangemsminerals,Tourmaline Pairs,Bicolour Pairs.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('da786566-d41c-488d-bb31-910082439cf1', '3.60 Cts Rainbow Bicolour Tourmaline', 'Multi Colour Rainbow Inside Tourmaline 

Exceptional And Rare

3.60 Cts
16.3 x 7.2 x 3.5mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 223, 1, 'loose_stone', 'Tourmaline', NULL, 3.6, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/da786566-d41c-488d-bb31-910082439cf1/etsy-1.jpg","https://media.gemworkers.com/items/da786566-d41c-488d-bb31-910082439cf1/etsy-2.jpg","https://media.gemworkers.com/items/da786566-d41c-488d-bb31-910082439cf1/etsy-3.jpg","https://media.gemworkers.com/items/da786566-d41c-488d-bb31-910082439cf1/etsy-4.jpg","https://media.gemworkers.com/items/da786566-d41c-488d-bb31-910082439cf1/etsy-5.jpg","https://media.gemworkers.com/items/da786566-d41c-488d-bb31-910082439cf1/etsy-6.jpg","https://media.gemworkers.com/items/da786566-d41c-488d-bb31-910082439cf1/etsy-7.jpg","https://media.gemworkers.com/items/da786566-d41c-488d-bb31-910082439cf1/etsy-8.jpg","https://media.gemworkers.com/items/da786566-d41c-488d-bb31-910082439cf1/etsy-9.jpg","https://media.gemworkers.com/items/da786566-d41c-488d-bb31-910082439cf1/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 250 USD, converted at ECB rate. Etsy tags: pink tourmaline,rings for women,unique tourmaline,jewels,Handmadejewellery,gift for her,Topqualitytourmaline,Bicolour Tourmaline,Unique Bicolour,Rare Tourmaline,Oceangemsminerals,Tourmaline Pairs,Bicolour Pairs.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('3be37dc2-6e27-4929-a237-0cc40cce338e', '12.10 Cts Rainbow Bicolour Tourmaline', 'Multi Colour Rainbow Inside Tourmaline 

Exceptional And Rare

12.10 Cts
26.2 x 9.8 x 4.7mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 715, 1, 'loose_stone', 'Tourmaline', NULL, 12.1, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/3be37dc2-6e27-4929-a237-0cc40cce338e/etsy-1.jpg","https://media.gemworkers.com/items/3be37dc2-6e27-4929-a237-0cc40cce338e/etsy-2.jpg","https://media.gemworkers.com/items/3be37dc2-6e27-4929-a237-0cc40cce338e/etsy-3.jpg","https://media.gemworkers.com/items/3be37dc2-6e27-4929-a237-0cc40cce338e/etsy-4.jpg","https://media.gemworkers.com/items/3be37dc2-6e27-4929-a237-0cc40cce338e/etsy-5.jpg","https://media.gemworkers.com/items/3be37dc2-6e27-4929-a237-0cc40cce338e/etsy-6.jpg","https://media.gemworkers.com/items/3be37dc2-6e27-4929-a237-0cc40cce338e/etsy-7.jpg","https://media.gemworkers.com/items/3be37dc2-6e27-4929-a237-0cc40cce338e/etsy-8.jpg","https://media.gemworkers.com/items/3be37dc2-6e27-4929-a237-0cc40cce338e/etsy-9.jpg","https://media.gemworkers.com/items/3be37dc2-6e27-4929-a237-0cc40cce338e/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 800 USD, converted at ECB rate. Etsy tags: pink tourmaline,rings for women,unique tourmaline,jewels,Handmadejewellery,gift for her,Topqualitytourmaline,Bicolour Tourmaline,Unique Bicolour,Rare Tourmaline,Oceangemsminerals,Tourmaline Pairs,Bicolour Pairs.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('cfbd1ac7-20ae-4973-87c9-51385a099e4e', '7.35 Cts Rainbow Bicolour Tourmaline', 'Multi Colour Rainbow Inside Tourmaline 

Exceptional And Rare

7.35 Cts
20.4 x 8.4 x 4.3mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 447, 1, 'loose_stone', 'Tourmaline', NULL, 7.35, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/cfbd1ac7-20ae-4973-87c9-51385a099e4e/etsy-1.jpg","https://media.gemworkers.com/items/cfbd1ac7-20ae-4973-87c9-51385a099e4e/etsy-2.jpg","https://media.gemworkers.com/items/cfbd1ac7-20ae-4973-87c9-51385a099e4e/etsy-3.jpg","https://media.gemworkers.com/items/cfbd1ac7-20ae-4973-87c9-51385a099e4e/etsy-4.jpg","https://media.gemworkers.com/items/cfbd1ac7-20ae-4973-87c9-51385a099e4e/etsy-5.jpg","https://media.gemworkers.com/items/cfbd1ac7-20ae-4973-87c9-51385a099e4e/etsy-6.jpg","https://media.gemworkers.com/items/cfbd1ac7-20ae-4973-87c9-51385a099e4e/etsy-7.jpg","https://media.gemworkers.com/items/cfbd1ac7-20ae-4973-87c9-51385a099e4e/etsy-8.jpg","https://media.gemworkers.com/items/cfbd1ac7-20ae-4973-87c9-51385a099e4e/etsy-9.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 500 USD, converted at ECB rate. Etsy tags: pink tourmaline,rings for women,unique tourmaline,jewels,Handmadejewellery,gift for her,Topqualitytourmaline,Bicolour Tourmaline,Unique Bicolour,Rare Tourmaline,Oceangemsminerals,Tourmaline Pairs,Bicolour Pairs.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('5bd9248b-a436-4a7a-860d-b4e3d1a24384', '10.50 Cts Rainbow Bicolour Tourmaline', 'Rare Bicolour Tourmaline With Coloured Stripes

10.50 Cts
17.6 x 11.1 x 5.9mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 402, 1, 'loose_stone', 'Tourmaline', NULL, 10.5, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/5bd9248b-a436-4a7a-860d-b4e3d1a24384/etsy-1.jpg","https://media.gemworkers.com/items/5bd9248b-a436-4a7a-860d-b4e3d1a24384/etsy-2.jpg","https://media.gemworkers.com/items/5bd9248b-a436-4a7a-860d-b4e3d1a24384/etsy-3.jpg","https://media.gemworkers.com/items/5bd9248b-a436-4a7a-860d-b4e3d1a24384/etsy-4.jpg","https://media.gemworkers.com/items/5bd9248b-a436-4a7a-860d-b4e3d1a24384/etsy-5.jpg","https://media.gemworkers.com/items/5bd9248b-a436-4a7a-860d-b4e3d1a24384/etsy-6.jpg","https://media.gemworkers.com/items/5bd9248b-a436-4a7a-860d-b4e3d1a24384/etsy-7.jpg","https://media.gemworkers.com/items/5bd9248b-a436-4a7a-860d-b4e3d1a24384/etsy-8.jpg","https://media.gemworkers.com/items/5bd9248b-a436-4a7a-860d-b4e3d1a24384/etsy-9.jpg","https://media.gemworkers.com/items/5bd9248b-a436-4a7a-860d-b4e3d1a24384/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 450 USD, converted at ECB rate. Etsy tags: pink tourmaline,rings for women,unique tourmaline,jewels,Handmadejewellery,gift for her,Topqualitytourmaline,Bicolour Tourmaline,Unique Bicolour,Rare Tourmaline,Oceangemsminerals,Tourmaline Pairs,Bicolour Pairs.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('1ef376e8-39a1-4332-97aa-8cc19c6b5f82', '7.65 Cts Soft Pink Natural Kunzite', 'Gorgeous Soft Pink Natural Kunzite 

7.65 Cts
12.6 x 8.8 x 8mm

Gorgeous Stone, High Lustre', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 107, 1, 'loose_stone', 'Kunzite', NULL, 7.65, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/1ef376e8-39a1-4332-97aa-8cc19c6b5f82/etsy-1.jpg","https://media.gemworkers.com/items/1ef376e8-39a1-4332-97aa-8cc19c6b5f82/etsy-2.jpg","https://media.gemworkers.com/items/1ef376e8-39a1-4332-97aa-8cc19c6b5f82/etsy-3.jpg","https://media.gemworkers.com/items/1ef376e8-39a1-4332-97aa-8cc19c6b5f82/etsy-4.jpg","https://media.gemworkers.com/items/1ef376e8-39a1-4332-97aa-8cc19c6b5f82/etsy-5.jpg","https://media.gemworkers.com/items/1ef376e8-39a1-4332-97aa-8cc19c6b5f82/etsy-6.jpg","https://media.gemworkers.com/items/1ef376e8-39a1-4332-97aa-8cc19c6b5f82/etsy-7.jpg","https://media.gemworkers.com/items/1ef376e8-39a1-4332-97aa-8cc19c6b5f82/etsy-8.jpg","https://media.gemworkers.com/items/1ef376e8-39a1-4332-97aa-8cc19c6b5f82/etsy-9.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 120 USD, converted at ECB rate. Etsy tags: Terminated Crystals,Jewellery Making,Aquamarine Specimen,Collectors,AquamarineCollection,Blue Aquamarine,Green Aquamarine,Gift For Her,Natural Stone,Kunzite Crystal,Heated Kunzite,Rough Kunzite,Kunzite Jewellery.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('90e53fe1-17a3-41de-862a-eb8851f3385e', '6.9 Cts Soft Pink Natural Kunzite', 'Gorgeous Soft Pink Natural Kunzite 

6.90 Cts
12 x 8.7 x 7.5mm

Gorgeous Stone, High Lustre', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 116, 1, 'loose_stone', 'Kunzite', NULL, 6.9, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/90e53fe1-17a3-41de-862a-eb8851f3385e/etsy-1.jpg","https://media.gemworkers.com/items/90e53fe1-17a3-41de-862a-eb8851f3385e/etsy-2.jpg","https://media.gemworkers.com/items/90e53fe1-17a3-41de-862a-eb8851f3385e/etsy-3.jpg","https://media.gemworkers.com/items/90e53fe1-17a3-41de-862a-eb8851f3385e/etsy-4.jpg","https://media.gemworkers.com/items/90e53fe1-17a3-41de-862a-eb8851f3385e/etsy-5.jpg","https://media.gemworkers.com/items/90e53fe1-17a3-41de-862a-eb8851f3385e/etsy-6.jpg","https://media.gemworkers.com/items/90e53fe1-17a3-41de-862a-eb8851f3385e/etsy-7.jpg","https://media.gemworkers.com/items/90e53fe1-17a3-41de-862a-eb8851f3385e/etsy-8.jpg","https://media.gemworkers.com/items/90e53fe1-17a3-41de-862a-eb8851f3385e/etsy-9.jpg","https://media.gemworkers.com/items/90e53fe1-17a3-41de-862a-eb8851f3385e/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 130 USD, converted at ECB rate. Etsy tags: Terminated Crystals,Jewellery Making,Aquamarine Specimen,Collectors,AquamarineCollection,Blue Aquamarine,Green Aquamarine,Gift For Her,Natural Stone,Kunzite Crystal,Heated Kunzite,Rough Kunzite,Kunzite Jewellery.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('9c21e6c9-7834-4448-8501-ec0db70c79d4', '7.9 Cts Soft Pink Natural Kunzite', 'Gorgeous Soft Pink Natural Kunzite 

7.90 Cts
11.1 x 10.1 x 8.6mm

Gorgeous Stone, High Lustre', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 107, 1, 'loose_stone', 'Kunzite', NULL, 7.9, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/9c21e6c9-7834-4448-8501-ec0db70c79d4/etsy-1.jpg","https://media.gemworkers.com/items/9c21e6c9-7834-4448-8501-ec0db70c79d4/etsy-2.jpg","https://media.gemworkers.com/items/9c21e6c9-7834-4448-8501-ec0db70c79d4/etsy-3.jpg","https://media.gemworkers.com/items/9c21e6c9-7834-4448-8501-ec0db70c79d4/etsy-4.jpg","https://media.gemworkers.com/items/9c21e6c9-7834-4448-8501-ec0db70c79d4/etsy-5.jpg","https://media.gemworkers.com/items/9c21e6c9-7834-4448-8501-ec0db70c79d4/etsy-6.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 120 USD, converted at ECB rate. Etsy tags: Terminated Crystals,Jewellery Making,Aquamarine Specimen,Collectors,AquamarineCollection,Blue Aquamarine,Green Aquamarine,Gift For Her,Natural Stone,Kunzite Crystal,Heated Kunzite,Rough Kunzite,Kunzite Jewellery.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('42a8636f-1a8c-4cd5-91f1-82ced80aeb0c', '3.4 Cts Green Tourmaline', 'Gorgeous Mesmerising Rare Green Natural Afghanistan Tourmaline 

More beautiful In real, One of a kind

The Weather Was Cloudy Couldn’t Capture The Colour

Loupe Clean

3.40 Cts 
11.9 x 6.2 x 4.3 mm

unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 536, 1, 'loose_stone', 'Tourmaline', NULL, 3.4, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/42a8636f-1a8c-4cd5-91f1-82ced80aeb0c/etsy-1.jpg","https://media.gemworkers.com/items/42a8636f-1a8c-4cd5-91f1-82ced80aeb0c/etsy-2.jpg","https://media.gemworkers.com/items/42a8636f-1a8c-4cd5-91f1-82ced80aeb0c/etsy-3.jpg","https://media.gemworkers.com/items/42a8636f-1a8c-4cd5-91f1-82ced80aeb0c/etsy-4.jpg","https://media.gemworkers.com/items/42a8636f-1a8c-4cd5-91f1-82ced80aeb0c/etsy-5.jpg","https://media.gemworkers.com/items/42a8636f-1a8c-4cd5-91f1-82ced80aeb0c/etsy-6.jpg","https://media.gemworkers.com/items/42a8636f-1a8c-4cd5-91f1-82ced80aeb0c/etsy-7.jpg","https://media.gemworkers.com/items/42a8636f-1a8c-4cd5-91f1-82ced80aeb0c/etsy-8.jpg","https://media.gemworkers.com/items/42a8636f-1a8c-4cd5-91f1-82ced80aeb0c/etsy-9.jpg","https://media.gemworkers.com/items/42a8636f-1a8c-4cd5-91f1-82ced80aeb0c/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 600 USD, converted at ECB rate. Etsy tags: Gold Rings,Rings For Men,Rings For Women,Gift For Her,Tourmaline Jewellery,Natural Stone,bicolour Tourmaline,Lagoon tourmaline,Bluegreen tourmaline,blue tourmaline,indigo tourmaline,Oceangemsminerals,rare tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('6aa0e9f1-6274-44eb-a45a-7108c4f69fe4', '6 Cts Blue Bicolour Tourmaline', 'Gorgeous Mesmerising Rare Bicolour Natural Afghanistan Tourmaline 

More beautiful In real, One of a kind

The Weather Was Cloudy Couldn’t Capture The Colour

6 Cts 

20.2 x 6.2 x 4.6mm

unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 536, 1, 'loose_stone', 'Tourmaline', NULL, 6, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/6aa0e9f1-6274-44eb-a45a-7108c4f69fe4/etsy-1.jpg","https://media.gemworkers.com/items/6aa0e9f1-6274-44eb-a45a-7108c4f69fe4/etsy-2.jpg","https://media.gemworkers.com/items/6aa0e9f1-6274-44eb-a45a-7108c4f69fe4/etsy-3.jpg","https://media.gemworkers.com/items/6aa0e9f1-6274-44eb-a45a-7108c4f69fe4/etsy-4.jpg","https://media.gemworkers.com/items/6aa0e9f1-6274-44eb-a45a-7108c4f69fe4/etsy-5.jpg","https://media.gemworkers.com/items/6aa0e9f1-6274-44eb-a45a-7108c4f69fe4/etsy-6.jpg","https://media.gemworkers.com/items/6aa0e9f1-6274-44eb-a45a-7108c4f69fe4/etsy-7.jpg","https://media.gemworkers.com/items/6aa0e9f1-6274-44eb-a45a-7108c4f69fe4/etsy-8.jpg","https://media.gemworkers.com/items/6aa0e9f1-6274-44eb-a45a-7108c4f69fe4/etsy-9.jpg","https://media.gemworkers.com/items/6aa0e9f1-6274-44eb-a45a-7108c4f69fe4/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 600 USD, converted at ECB rate. Etsy tags: Gold Rings,Rings For Men,Rings For Women,Gift For Her,Tourmaline Jewellery,Natural Stone,bicolour Tourmaline,Lagoon tourmaline,Bluegreen tourmaline,blue tourmaline,indigo tourmaline,Oceangemsminerals,rare tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('acae9fea-817d-47a2-ae90-4e06e6c99dba', '8.55 Cts Calibrated Size Tourmaline', 'Calibrated Size Step Cushion Cut Tourmalines

top colour high lustre and brilliance 

Perfectly Cut

8.55 Cts 

4.1 x 4 x 3.1 mm
4.2 x 4.2 x 3.4 mm

100% natural no treatment whatsoever.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 1161, 1, 'loose_stone', 'Tourmaline', NULL, 8.55, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/acae9fea-817d-47a2-ae90-4e06e6c99dba/etsy-1.jpg","https://media.gemworkers.com/items/acae9fea-817d-47a2-ae90-4e06e6c99dba/etsy-2.jpg","https://media.gemworkers.com/items/acae9fea-817d-47a2-ae90-4e06e6c99dba/etsy-3.jpg","https://media.gemworkers.com/items/acae9fea-817d-47a2-ae90-4e06e6c99dba/etsy-4.jpg","https://media.gemworkers.com/items/acae9fea-817d-47a2-ae90-4e06e6c99dba/etsy-5.jpg","https://media.gemworkers.com/items/acae9fea-817d-47a2-ae90-4e06e6c99dba/etsy-6.jpg","https://media.gemworkers.com/items/acae9fea-817d-47a2-ae90-4e06e6c99dba/etsy-7.jpg","https://media.gemworkers.com/items/acae9fea-817d-47a2-ae90-4e06e6c99dba/etsy-8.jpg","https://media.gemworkers.com/items/acae9fea-817d-47a2-ae90-4e06e6c99dba/etsy-9.jpg","https://media.gemworkers.com/items/acae9fea-817d-47a2-ae90-4e06e6c99dba/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 1300 USD, converted at ECB rate. Etsy tags: Natural Stone,Jewellery Supplies,Jewellery Making,Jewellery Findings,y2k stud earrings,Gift For Her,Rings For Men,Rings For Women,Gold Rings,Silver Sterling,Garnet Necklace,Garnet Rings,Garnet Jewellery.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('ffbbac87-101d-447a-b162-c97963f98444', '10.10 Cts Calibrated Size Tourmaline', 'Calibrated Size Step Cushion Cut Tourmalines

top colour high lustre and brilliance 

Perfectly Cut

10.10 Cts 

4 x 3.5 x 2.5 mm
4 x 3.7 x 2.8 mm

100% natural no treatment whatsoever.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 1429, 1, 'loose_stone', 'Tourmaline', NULL, 10.1, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/ffbbac87-101d-447a-b162-c97963f98444/etsy-1.jpg","https://media.gemworkers.com/items/ffbbac87-101d-447a-b162-c97963f98444/etsy-2.jpg","https://media.gemworkers.com/items/ffbbac87-101d-447a-b162-c97963f98444/etsy-3.jpg","https://media.gemworkers.com/items/ffbbac87-101d-447a-b162-c97963f98444/etsy-4.jpg","https://media.gemworkers.com/items/ffbbac87-101d-447a-b162-c97963f98444/etsy-5.jpg","https://media.gemworkers.com/items/ffbbac87-101d-447a-b162-c97963f98444/etsy-6.jpg","https://media.gemworkers.com/items/ffbbac87-101d-447a-b162-c97963f98444/etsy-7.jpg","https://media.gemworkers.com/items/ffbbac87-101d-447a-b162-c97963f98444/etsy-8.jpg","https://media.gemworkers.com/items/ffbbac87-101d-447a-b162-c97963f98444/etsy-9.jpg","https://media.gemworkers.com/items/ffbbac87-101d-447a-b162-c97963f98444/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 1600 USD, converted at ECB rate. Etsy tags: Natural Stone,Jewellery Supplies,Jewellery Making,Jewellery Findings,y2k stud earrings,Gift For Her,Rings For Men,Rings For Women,Gold Rings,Silver Sterling,Garnet Necklace,Garnet Rings,Garnet Jewellery.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('c16c2678-018a-4806-b77c-38f66a9aa8fa', '6.35 Cts Calibrated Size Tourmaline', 'Calibrated Size Step Cushion Cut Tourmalines

top colour high lustre and brilliance 

Perfectly Cut

6.35 cts 

3.5 x 3.7 x 2.7 mm
3.8 x 3.8 2.9 mm

100% natural no treatment whatsoever.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 893, 1, 'loose_stone', 'Tourmaline', NULL, 6.35, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/c16c2678-018a-4806-b77c-38f66a9aa8fa/etsy-1.jpg","https://media.gemworkers.com/items/c16c2678-018a-4806-b77c-38f66a9aa8fa/etsy-2.jpg","https://media.gemworkers.com/items/c16c2678-018a-4806-b77c-38f66a9aa8fa/etsy-3.jpg","https://media.gemworkers.com/items/c16c2678-018a-4806-b77c-38f66a9aa8fa/etsy-4.jpg","https://media.gemworkers.com/items/c16c2678-018a-4806-b77c-38f66a9aa8fa/etsy-5.jpg","https://media.gemworkers.com/items/c16c2678-018a-4806-b77c-38f66a9aa8fa/etsy-6.jpg","https://media.gemworkers.com/items/c16c2678-018a-4806-b77c-38f66a9aa8fa/etsy-7.jpg","https://media.gemworkers.com/items/c16c2678-018a-4806-b77c-38f66a9aa8fa/etsy-8.jpg","https://media.gemworkers.com/items/c16c2678-018a-4806-b77c-38f66a9aa8fa/etsy-9.jpg","https://media.gemworkers.com/items/c16c2678-018a-4806-b77c-38f66a9aa8fa/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 1000 USD, converted at ECB rate. Etsy tags: Natural Stone,Jewellery Supplies,Jewellery Making,Jewellery Findings,y2k stud earrings,Gift For Her,Rings For Men,Rings For Women,Gold Rings,Silver Sterling,Garnet Necklace,Garnet Rings,Garnet Jewellery.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('633aac8b-1c79-453f-951e-7ac8a2a5a73b', '7.95 Cts Rare Bicolour Tourmaline Pair', 'To All The Bicolour Lovers Here Is An Incredible Opportunity Buy A Truly Exceptional And One Of A Kind Bicolour Tourmaline Pair

7.95 Cts 
11.2 x 7.3 x 4.8mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 715, 1, 'loose_stone', 'Tourmaline', NULL, 7.95, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/633aac8b-1c79-453f-951e-7ac8a2a5a73b/etsy-1.jpg","https://media.gemworkers.com/items/633aac8b-1c79-453f-951e-7ac8a2a5a73b/etsy-2.jpg","https://media.gemworkers.com/items/633aac8b-1c79-453f-951e-7ac8a2a5a73b/etsy-3.jpg","https://media.gemworkers.com/items/633aac8b-1c79-453f-951e-7ac8a2a5a73b/etsy-4.jpg","https://media.gemworkers.com/items/633aac8b-1c79-453f-951e-7ac8a2a5a73b/etsy-5.jpg","https://media.gemworkers.com/items/633aac8b-1c79-453f-951e-7ac8a2a5a73b/etsy-6.jpg","https://media.gemworkers.com/items/633aac8b-1c79-453f-951e-7ac8a2a5a73b/etsy-7.jpg","https://media.gemworkers.com/items/633aac8b-1c79-453f-951e-7ac8a2a5a73b/etsy-8.jpg","https://media.gemworkers.com/items/633aac8b-1c79-453f-951e-7ac8a2a5a73b/etsy-9.jpg","https://media.gemworkers.com/items/633aac8b-1c79-453f-951e-7ac8a2a5a73b/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 800 USD, converted at ECB rate. Etsy tags: pink tourmaline,rings for women,unique tourmaline,jewels,Handmadejewellery,gift for her,Topqualitytourmaline,Bicolour Tourmaline,Unique Bicolour,Rare Tourmaline,Oceangemsminerals,Tourmaline Pairs,Bicolour Pairs.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('8687269a-ae99-4452-868d-52152f3a0791', '4.6 Cts Rare Bicolour Tourmaline', 'To All The Bicolour Lovers Here Is An Incredible Opportunity Buy A Truly Exceptional And One Of A Kind Bicolour Tourmaline

4.60 cts 
15 x 6.7 x 4.4mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 357, 1, 'loose_stone', 'Tourmaline', NULL, 4.6, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/8687269a-ae99-4452-868d-52152f3a0791/etsy-1.jpg","https://media.gemworkers.com/items/8687269a-ae99-4452-868d-52152f3a0791/etsy-2.jpg","https://media.gemworkers.com/items/8687269a-ae99-4452-868d-52152f3a0791/etsy-3.jpg","https://media.gemworkers.com/items/8687269a-ae99-4452-868d-52152f3a0791/etsy-4.jpg","https://media.gemworkers.com/items/8687269a-ae99-4452-868d-52152f3a0791/etsy-5.jpg","https://media.gemworkers.com/items/8687269a-ae99-4452-868d-52152f3a0791/etsy-6.jpg","https://media.gemworkers.com/items/8687269a-ae99-4452-868d-52152f3a0791/etsy-7.jpg","https://media.gemworkers.com/items/8687269a-ae99-4452-868d-52152f3a0791/etsy-8.jpg","https://media.gemworkers.com/items/8687269a-ae99-4452-868d-52152f3a0791/etsy-9.jpg","https://media.gemworkers.com/items/8687269a-ae99-4452-868d-52152f3a0791/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 400 USD, converted at ECB rate. Etsy tags: pink tourmaline,rings for women,unique tourmaline,jewels,Handmadejewellery,gift for her,Topqualitytourmaline,Bicolour Tourmaline,Unique Bicolour,Rare Tourmaline,Oceangemsminerals,Tourmaline Pairs,Bicolour Pairs.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('db970918-7405-4bec-be23-7718a8bb793f', '1.3 Cts Rare Bicolour Tourmaline', 'To All The Bicolour Lovers Here Is An Incredible Opportunity Buy A Truly Exceptional And One Of A Kind Bicolour Tourmaline

1.30 Cts 
10.6 x 4.2 x 2.8 mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 179, 1, 'loose_stone', 'Tourmaline', NULL, 1.3, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/db970918-7405-4bec-be23-7718a8bb793f/etsy-1.jpg","https://media.gemworkers.com/items/db970918-7405-4bec-be23-7718a8bb793f/etsy-2.jpg","https://media.gemworkers.com/items/db970918-7405-4bec-be23-7718a8bb793f/etsy-3.jpg","https://media.gemworkers.com/items/db970918-7405-4bec-be23-7718a8bb793f/etsy-4.jpg","https://media.gemworkers.com/items/db970918-7405-4bec-be23-7718a8bb793f/etsy-5.jpg","https://media.gemworkers.com/items/db970918-7405-4bec-be23-7718a8bb793f/etsy-6.jpg","https://media.gemworkers.com/items/db970918-7405-4bec-be23-7718a8bb793f/etsy-7.jpg","https://media.gemworkers.com/items/db970918-7405-4bec-be23-7718a8bb793f/etsy-8.jpg","https://media.gemworkers.com/items/db970918-7405-4bec-be23-7718a8bb793f/etsy-9.jpg","https://media.gemworkers.com/items/db970918-7405-4bec-be23-7718a8bb793f/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 200 USD, converted at ECB rate. Etsy tags: pink tourmaline,rings for women,unique tourmaline,jewels,Handmadejewellery,gift for her,Topqualitytourmaline,Bicolour Tourmaline,Unique Bicolour,Rare Tourmaline,Oceangemsminerals,Tourmaline Pairs,Bicolour Pairs.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('c429b447-984f-4944-a402-fefa56eea1d3', '23+ Cts Blue And Seafoam Cabochon Lot', 'Gorgeous High Lustre Cabochon blue amd seafoam Colour Tourmaline 

High Quality Cabochon

23.60 carats 

Size:5mm to 8mm

unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 179, 1, 'loose_stone', 'Tourmaline', NULL, NULL, NULL, NULL, NULL, NULL, '["https://media.gemworkers.com/items/c429b447-984f-4944-a402-fefa56eea1d3/etsy-1.jpg","https://media.gemworkers.com/items/c429b447-984f-4944-a402-fefa56eea1d3/etsy-2.jpg","https://media.gemworkers.com/items/c429b447-984f-4944-a402-fefa56eea1d3/etsy-3.jpg","https://media.gemworkers.com/items/c429b447-984f-4944-a402-fefa56eea1d3/etsy-4.jpg","https://media.gemworkers.com/items/c429b447-984f-4944-a402-fefa56eea1d3/etsy-5.jpg","https://media.gemworkers.com/items/c429b447-984f-4944-a402-fefa56eea1d3/etsy-6.jpg","https://media.gemworkers.com/items/c429b447-984f-4944-a402-fefa56eea1d3/etsy-7.jpg","https://media.gemworkers.com/items/c429b447-984f-4944-a402-fefa56eea1d3/etsy-8.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 200 USD, converted at ECB rate. Etsy tags: Rings For Men,Tourmaline Jewellery,Natural Stone,bicolour Tourmaline,Lagoon tourmaline,Bluegreen tourmaline,blue tourmaline,tourmaline rings,faceted tourmaline,Oceangemsminerals,Paraiba Tourmaline,Paraiba Cabochon,Blue Cabochons.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('08568ac7-e808-4499-85da-b6b9a883c1a6', '26.70 Cts Green Tourmaline Pair', 'A Very High Lustre Unique Colour Tourmaline 

Gorgeous Long Emerald Cut Pair

High Quality Fine Cut

26.70 Cts
32.2 x 7.8 x 5.1mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 535, 1, 'loose_stone', 'Tourmaline', NULL, 26.7, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/08568ac7-e808-4499-85da-b6b9a883c1a6/etsy-1.jpg","https://media.gemworkers.com/items/08568ac7-e808-4499-85da-b6b9a883c1a6/etsy-2.jpg","https://media.gemworkers.com/items/08568ac7-e808-4499-85da-b6b9a883c1a6/etsy-3.jpg","https://media.gemworkers.com/items/08568ac7-e808-4499-85da-b6b9a883c1a6/etsy-4.jpg","https://media.gemworkers.com/items/08568ac7-e808-4499-85da-b6b9a883c1a6/etsy-5.jpg","https://media.gemworkers.com/items/08568ac7-e808-4499-85da-b6b9a883c1a6/etsy-6.jpg","https://media.gemworkers.com/items/08568ac7-e808-4499-85da-b6b9a883c1a6/etsy-7.jpg","https://media.gemworkers.com/items/08568ac7-e808-4499-85da-b6b9a883c1a6/etsy-8.jpg","https://media.gemworkers.com/items/08568ac7-e808-4499-85da-b6b9a883c1a6/etsy-9.jpg","https://media.gemworkers.com/items/08568ac7-e808-4499-85da-b6b9a883c1a6/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 599 USD, converted at ECB rate. Etsy tags: Tourmaline Earrings,Earrings Set,Fine Tourmaline,Canary Tourmaline,Lagoon Tourmaline,Blue Tourmaline,Yellow Tourmaline,Stud Earrings,Tourmaline Jewellery,Jewellery Set,Oceangemsminerals,Tourmaline Pairs,Lagoon Pairs.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('32dda86e-54f3-4fbe-a58c-b6e15d577f71', '13.20 Cts Tourmaline Pair', 'A Very High Lustre Unique Colour Tourmaline 

Gorgeous Long Hexagon Shaped Pair

High Quality Fine Cut

13.20 Cts
33 x 5.4 x 3.7mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 357, 1, 'loose_stone', 'Tourmaline', NULL, 13.2, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/32dda86e-54f3-4fbe-a58c-b6e15d577f71/etsy-1.jpg","https://media.gemworkers.com/items/32dda86e-54f3-4fbe-a58c-b6e15d577f71/etsy-2.jpg","https://media.gemworkers.com/items/32dda86e-54f3-4fbe-a58c-b6e15d577f71/etsy-3.jpg","https://media.gemworkers.com/items/32dda86e-54f3-4fbe-a58c-b6e15d577f71/etsy-4.jpg","https://media.gemworkers.com/items/32dda86e-54f3-4fbe-a58c-b6e15d577f71/etsy-5.jpg","https://media.gemworkers.com/items/32dda86e-54f3-4fbe-a58c-b6e15d577f71/etsy-6.jpg","https://media.gemworkers.com/items/32dda86e-54f3-4fbe-a58c-b6e15d577f71/etsy-7.jpg","https://media.gemworkers.com/items/32dda86e-54f3-4fbe-a58c-b6e15d577f71/etsy-8.jpg","https://media.gemworkers.com/items/32dda86e-54f3-4fbe-a58c-b6e15d577f71/etsy-9.jpg","https://media.gemworkers.com/items/32dda86e-54f3-4fbe-a58c-b6e15d577f71/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 400 USD, converted at ECB rate. Etsy tags: Tourmaline Earrings,Earrings Set,Fine Tourmaline,Canary Tourmaline,Lagoon Tourmaline,Blue Tourmaline,Yellow Tourmaline,Stud Earrings,Tourmaline Jewellery,Jewellery Set,Oceangemsminerals,Tourmaline Pairs,Lagoon Pairs.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('e207cf60-bdb2-48c7-8502-44ba606f26dd', '6.40 Cts Tourmaline Pairs', 'A Very High Lustre Unique Colour Tourmaline Set  

High Quality Fine Cut

6.40 Cts
12.5 x 4.2 x 3.2mm
14.6 x 4.2 x 2.8mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 357, 1, 'loose_stone', 'Tourmaline', NULL, 6.4, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/e207cf60-bdb2-48c7-8502-44ba606f26dd/etsy-1.jpg","https://media.gemworkers.com/items/e207cf60-bdb2-48c7-8502-44ba606f26dd/etsy-2.jpg","https://media.gemworkers.com/items/e207cf60-bdb2-48c7-8502-44ba606f26dd/etsy-3.jpg","https://media.gemworkers.com/items/e207cf60-bdb2-48c7-8502-44ba606f26dd/etsy-4.jpg","https://media.gemworkers.com/items/e207cf60-bdb2-48c7-8502-44ba606f26dd/etsy-5.jpg","https://media.gemworkers.com/items/e207cf60-bdb2-48c7-8502-44ba606f26dd/etsy-6.jpg","https://media.gemworkers.com/items/e207cf60-bdb2-48c7-8502-44ba606f26dd/etsy-7.jpg","https://media.gemworkers.com/items/e207cf60-bdb2-48c7-8502-44ba606f26dd/etsy-8.jpg","https://media.gemworkers.com/items/e207cf60-bdb2-48c7-8502-44ba606f26dd/etsy-9.jpg","https://media.gemworkers.com/items/e207cf60-bdb2-48c7-8502-44ba606f26dd/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 400 USD, converted at ECB rate. Etsy tags: Tourmaline Earrings,Earrings Set,Fine Tourmaline,Canary Tourmaline,Lagoon Tourmaline,Blue Tourmaline,Yellow Tourmaline,Stud Earrings,Tourmaline Jewellery,Jewellery Set,Oceangemsminerals,Tourmaline Pairs,Lagoon Pairs.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('59194c4b-fd65-48bd-a164-d8bdb12b7031', '2.35 Cts Watermelon Bicolour Tourmaline', 'Sweet Bicolour Tourmaline 

Unique And Rare Colour

2.35 Cts
11.7 x 5 x 3.9mm

No treatment.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 197, 1, 'loose_stone', 'Tourmaline', 'Watermelon', 2.35, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/59194c4b-fd65-48bd-a164-d8bdb12b7031/etsy-1.jpg","https://media.gemworkers.com/items/59194c4b-fd65-48bd-a164-d8bdb12b7031/etsy-2.jpg","https://media.gemworkers.com/items/59194c4b-fd65-48bd-a164-d8bdb12b7031/etsy-3.jpg","https://media.gemworkers.com/items/59194c4b-fd65-48bd-a164-d8bdb12b7031/etsy-4.jpg","https://media.gemworkers.com/items/59194c4b-fd65-48bd-a164-d8bdb12b7031/etsy-5.jpg","https://media.gemworkers.com/items/59194c4b-fd65-48bd-a164-d8bdb12b7031/etsy-6.jpg","https://media.gemworkers.com/items/59194c4b-fd65-48bd-a164-d8bdb12b7031/etsy-7.jpg","https://media.gemworkers.com/items/59194c4b-fd65-48bd-a164-d8bdb12b7031/etsy-8.jpg","https://media.gemworkers.com/items/59194c4b-fd65-48bd-a164-d8bdb12b7031/etsy-9.jpg","https://media.gemworkers.com/items/59194c4b-fd65-48bd-a164-d8bdb12b7031/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 220 USD, converted at ECB rate. Etsy tags: Tourmaline Jewellery,Tourmaline Earrings,Earrings Stud,y2k earrings stud,Gold Rings,Natural Stone,Gift For Her,Rings For Men,Oceangemsminerals,lagoon tourmaline,tourmaline pairs,bicolour tourmaline,Watermelon Bicolour.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('02ef9063-488a-4ef1-9dad-2b6c77765390', '1.20 Cts Watermelon Bicolour Tourmaline', 'Sweet Bicolour Tourmaline 

Unique And Rare Colour

1.20 Cts
19.6 x 2.2 x 2mm

No treatment.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 143, 1, 'loose_stone', 'Tourmaline', 'Watermelon', 1.2, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/02ef9063-488a-4ef1-9dad-2b6c77765390/etsy-1.jpg","https://media.gemworkers.com/items/02ef9063-488a-4ef1-9dad-2b6c77765390/etsy-2.jpg","https://media.gemworkers.com/items/02ef9063-488a-4ef1-9dad-2b6c77765390/etsy-3.jpg","https://media.gemworkers.com/items/02ef9063-488a-4ef1-9dad-2b6c77765390/etsy-4.jpg","https://media.gemworkers.com/items/02ef9063-488a-4ef1-9dad-2b6c77765390/etsy-5.jpg","https://media.gemworkers.com/items/02ef9063-488a-4ef1-9dad-2b6c77765390/etsy-6.jpg","https://media.gemworkers.com/items/02ef9063-488a-4ef1-9dad-2b6c77765390/etsy-7.jpg","https://media.gemworkers.com/items/02ef9063-488a-4ef1-9dad-2b6c77765390/etsy-8.jpg","https://media.gemworkers.com/items/02ef9063-488a-4ef1-9dad-2b6c77765390/etsy-9.jpg","https://media.gemworkers.com/items/02ef9063-488a-4ef1-9dad-2b6c77765390/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 160 USD, converted at ECB rate. Etsy tags: Tourmaline Jewellery,Tourmaline Earrings,Earrings Stud,y2k earrings stud,Gold Rings,Natural Stone,Gift For Her,Rings For Men,Oceangemsminerals,lagoon tourmaline,tourmaline pairs,bicolour tourmaline,Watermelon Bicolour.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('81579116-9fb2-4011-97a3-c1ce3e9db441', '6.50 Cts Bicolour Tourmaline', 'Gorgeous Unique Bicolour tourmaline 

Good Size And Lustre

6.50 Cts
12 x 8 x 6.5mm

Unheated Untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 210, 1, 'loose_stone', 'Tourmaline', NULL, 6.5, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/81579116-9fb2-4011-97a3-c1ce3e9db441/etsy-1.jpg","https://media.gemworkers.com/items/81579116-9fb2-4011-97a3-c1ce3e9db441/etsy-2.jpg","https://media.gemworkers.com/items/81579116-9fb2-4011-97a3-c1ce3e9db441/etsy-3.jpg","https://media.gemworkers.com/items/81579116-9fb2-4011-97a3-c1ce3e9db441/etsy-4.jpg","https://media.gemworkers.com/items/81579116-9fb2-4011-97a3-c1ce3e9db441/etsy-5.jpg","https://media.gemworkers.com/items/81579116-9fb2-4011-97a3-c1ce3e9db441/etsy-6.jpg","https://media.gemworkers.com/items/81579116-9fb2-4011-97a3-c1ce3e9db441/etsy-7.jpg","https://media.gemworkers.com/items/81579116-9fb2-4011-97a3-c1ce3e9db441/etsy-8.jpg","https://media.gemworkers.com/items/81579116-9fb2-4011-97a3-c1ce3e9db441/etsy-9.jpg","https://media.gemworkers.com/items/81579116-9fb2-4011-97a3-c1ce3e9db441/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 235 USD, converted at ECB rate. Etsy tags: Bicolour Tourmaline,Tourmaline Jewellery,Tourmaline Rings,Tourmaline Necklace,Pink Tourmaline,Rare Tourmaline,Unique Tourmaline,Tourmaline Supplies,Jewellery Making,Jewellery Supplies,Jewellery Finding,Natural Stone,Oceangemsminerals.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('ce5b0aef-24cc-4666-80a5-1003159bd24f', '8.20 Cts Tourmaline Lot', 'Beautiful Mix Size Tourmaline Lot

8.20 Cts
5 to 11mm

no treatment whatsoever', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 107, 1, 'loose_stone', 'Tourmaline', NULL, 8.2, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/ce5b0aef-24cc-4666-80a5-1003159bd24f/etsy-1.jpg","https://media.gemworkers.com/items/ce5b0aef-24cc-4666-80a5-1003159bd24f/etsy-2.jpg","https://media.gemworkers.com/items/ce5b0aef-24cc-4666-80a5-1003159bd24f/etsy-3.jpg","https://media.gemworkers.com/items/ce5b0aef-24cc-4666-80a5-1003159bd24f/etsy-4.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 120 USD, converted at ECB rate. Etsy tags: Jewellery Making,Jewellery Supplies,Jewellery Findings,Tourmaline Lot,Seafoam Tourmaline,Green Tourmaline,Tourmaline Jewellery,Gift For Her,Natural Stone,Pink Tourmaline,Stud Earrings,Hoop earrings,handmade.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('a5d81d30-3f94-4661-a190-eb66c580ca1e', '14 Cts Tourmaline Lot For Necklace', 'Gorgeous Tourmaline Lot For Necklace 

good lustre and nice polish

Blue And Green Colours

14 Cts
13.9 to 3.6mm

unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 188, 1, 'jewelry', 'Tourmaline', NULL, 14, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/a5d81d30-3f94-4661-a190-eb66c580ca1e/etsy-1.jpg","https://media.gemworkers.com/items/a5d81d30-3f94-4661-a190-eb66c580ca1e/etsy-2.jpg","https://media.gemworkers.com/items/a5d81d30-3f94-4661-a190-eb66c580ca1e/etsy-3.jpg","https://media.gemworkers.com/items/a5d81d30-3f94-4661-a190-eb66c580ca1e/etsy-4.jpg","https://media.gemworkers.com/items/a5d81d30-3f94-4661-a190-eb66c580ca1e/etsy-5.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 210 USD, converted at ECB rate. Etsy tags: Bicolour Tourmaline,Pink Tourmaline,AppleGreenTourmaline,tourmaline rings,unique tourmaline,rare tourmaline,Handmadejewellery,jewellers,gift for her,natural stone,lagoon tourmaline,olive tourmaline,Green Tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('439af454-2c17-488d-aded-53355fceb98a', '6.8 Cts Red Rubilite Tourmaline', 'Gorgeous Red colour Rubilite Tourmaline

6.80 Cts
12 x 9.5 x 7.1mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 357, 1, 'loose_stone', 'Tourmaline', 'Rubellite', 6.8, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/439af454-2c17-488d-aded-53355fceb98a/etsy-1.jpg","https://media.gemworkers.com/items/439af454-2c17-488d-aded-53355fceb98a/etsy-2.jpg","https://media.gemworkers.com/items/439af454-2c17-488d-aded-53355fceb98a/etsy-3.jpg","https://media.gemworkers.com/items/439af454-2c17-488d-aded-53355fceb98a/etsy-4.jpg","https://media.gemworkers.com/items/439af454-2c17-488d-aded-53355fceb98a/etsy-5.jpg","https://media.gemworkers.com/items/439af454-2c17-488d-aded-53355fceb98a/etsy-6.jpg","https://media.gemworkers.com/items/439af454-2c17-488d-aded-53355fceb98a/etsy-7.jpg","https://media.gemworkers.com/items/439af454-2c17-488d-aded-53355fceb98a/etsy-8.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 400 USD, converted at ECB rate. Etsy tags: Red Rubilite,PigeonBlood Rubilite,Orange Rubilite,Pinkish Rubilite,Red Tourmaline,Pink Tourmaline,Orange Tourmaline,Cushion Cut,Tourmaline Jewellery,Tourmaline Faceted,Rubilite Tourmaline,Jewellery Making,Jewellery Findings.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('e7402d26-37a5-4bef-9045-4b026505a3b1', '10.55 Cts Red Rubilite Tourmaline', 'Gorgeous Red colour Rubilite Tourmaline

10.55 Cts
14.6 x 10.2 x 7.4mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 715, 1, 'loose_stone', 'Tourmaline', 'Rubellite', 10.55, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/e7402d26-37a5-4bef-9045-4b026505a3b1/etsy-1.jpg","https://media.gemworkers.com/items/e7402d26-37a5-4bef-9045-4b026505a3b1/etsy-2.jpg","https://media.gemworkers.com/items/e7402d26-37a5-4bef-9045-4b026505a3b1/etsy-3.jpg","https://media.gemworkers.com/items/e7402d26-37a5-4bef-9045-4b026505a3b1/etsy-4.jpg","https://media.gemworkers.com/items/e7402d26-37a5-4bef-9045-4b026505a3b1/etsy-5.jpg","https://media.gemworkers.com/items/e7402d26-37a5-4bef-9045-4b026505a3b1/etsy-6.jpg","https://media.gemworkers.com/items/e7402d26-37a5-4bef-9045-4b026505a3b1/etsy-7.jpg","https://media.gemworkers.com/items/e7402d26-37a5-4bef-9045-4b026505a3b1/etsy-8.jpg","https://media.gemworkers.com/items/e7402d26-37a5-4bef-9045-4b026505a3b1/etsy-9.jpg","https://media.gemworkers.com/items/e7402d26-37a5-4bef-9045-4b026505a3b1/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 800 USD, converted at ECB rate. Etsy tags: Red Rubilite,PigeonBlood Rubilite,Orange Rubilite,Pinkish Rubilite,Red Tourmaline,Pink Tourmaline,Orange Tourmaline,Cushion Cut,Tourmaline Jewellery,Tourmaline Faceted,Rubilite Tourmaline,Jewellery Making,Jewellery Findings.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('bc1485ec-adc0-43dd-bcaf-da5bea28ddc7', '4.80 Cts Blue Bicolour Tourmaline.', 'Rare And Bright Blue Colour Mesmerising Afghan Tourmaline.

Unique And One of a kind.

4.80 Cts
17.5 x 5 x 5mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 169, 1, 'loose_stone', 'Tourmaline', NULL, 4.8, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/bc1485ec-adc0-43dd-bcaf-da5bea28ddc7/etsy-1.jpg","https://media.gemworkers.com/items/bc1485ec-adc0-43dd-bcaf-da5bea28ddc7/etsy-2.jpg","https://media.gemworkers.com/items/bc1485ec-adc0-43dd-bcaf-da5bea28ddc7/etsy-3.jpg","https://media.gemworkers.com/items/bc1485ec-adc0-43dd-bcaf-da5bea28ddc7/etsy-4.jpg","https://media.gemworkers.com/items/bc1485ec-adc0-43dd-bcaf-da5bea28ddc7/etsy-5.jpg","https://media.gemworkers.com/items/bc1485ec-adc0-43dd-bcaf-da5bea28ddc7/etsy-6.jpg","https://media.gemworkers.com/items/bc1485ec-adc0-43dd-bcaf-da5bea28ddc7/etsy-7.jpg","https://media.gemworkers.com/items/bc1485ec-adc0-43dd-bcaf-da5bea28ddc7/etsy-8.jpg","https://media.gemworkers.com/items/bc1485ec-adc0-43dd-bcaf-da5bea28ddc7/etsy-9.jpg","https://media.gemworkers.com/items/bc1485ec-adc0-43dd-bcaf-da5bea28ddc7/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 189 USD, converted at ECB rate. Etsy tags: Neon Blue Tourmaline,Bicolour Blue,Unique Tourmaline,Rare Tourmaline,Paraiba Tourmaline,Blue Tourmaline,Lagoon Tourmaline,Lagoon Bicolour,Oceangemsminerals,Tourmaline Rings,Tourmaline Jewellery,Gift For Her,Ink blue tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('5a53394f-eb35-4cf2-a6b6-05e4c02e9f60', '37.50 Cts Rubilite Cabochon Lot', 'Gorgeous Rubilite Cabochon Lot

High Lustre And Nice Polished

37.50 Cts
19.5 to 9.1mm

unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 179, 1, 'loose_stone', 'Tourmaline', 'Rubellite', 37.5, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/5a53394f-eb35-4cf2-a6b6-05e4c02e9f60/etsy-1.jpg","https://media.gemworkers.com/items/5a53394f-eb35-4cf2-a6b6-05e4c02e9f60/etsy-2.jpg","https://media.gemworkers.com/items/5a53394f-eb35-4cf2-a6b6-05e4c02e9f60/etsy-3.jpg","https://media.gemworkers.com/items/5a53394f-eb35-4cf2-a6b6-05e4c02e9f60/etsy-4.jpg","https://media.gemworkers.com/items/5a53394f-eb35-4cf2-a6b6-05e4c02e9f60/etsy-5.jpg","https://media.gemworkers.com/items/5a53394f-eb35-4cf2-a6b6-05e4c02e9f60/etsy-6.jpg","https://media.gemworkers.com/items/5a53394f-eb35-4cf2-a6b6-05e4c02e9f60/etsy-7.jpg","https://media.gemworkers.com/items/5a53394f-eb35-4cf2-a6b6-05e4c02e9f60/etsy-8.jpg","https://media.gemworkers.com/items/5a53394f-eb35-4cf2-a6b6-05e4c02e9f60/etsy-9.jpg","https://media.gemworkers.com/items/5a53394f-eb35-4cf2-a6b6-05e4c02e9f60/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 200 USD, converted at ECB rate. Etsy tags: Santa Maria Cabochon,Bicolour Cabochons,Blue Cabochons,Lagoon Cabochons,Natural Stone,jewels,Oceangemsminerals,Tourmaline Rosecuts,Lagoon Rosecuts,Blue Tourmaline,Blue Rosecuts,Pink Cabochon,Green Cabochon.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('643e2426-a20f-4c78-a46a-b562aa186ca8', '10.40 Cts Bicolour Tourmaline', 'Natural Rare Bicolour mesmerising tourmaline 

Sugar Inclusion Sweet Stone

10.40 Cts
14 x 10.5 x 8.2mm

unheated,', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 447, 1, 'loose_stone', 'Tourmaline', NULL, 10.4, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/643e2426-a20f-4c78-a46a-b562aa186ca8/etsy-1.jpg","https://media.gemworkers.com/items/643e2426-a20f-4c78-a46a-b562aa186ca8/etsy-2.jpg","https://media.gemworkers.com/items/643e2426-a20f-4c78-a46a-b562aa186ca8/etsy-3.jpg","https://media.gemworkers.com/items/643e2426-a20f-4c78-a46a-b562aa186ca8/etsy-4.jpg","https://media.gemworkers.com/items/643e2426-a20f-4c78-a46a-b562aa186ca8/etsy-5.jpg","https://media.gemworkers.com/items/643e2426-a20f-4c78-a46a-b562aa186ca8/etsy-6.jpg","https://media.gemworkers.com/items/643e2426-a20f-4c78-a46a-b562aa186ca8/etsy-7.jpg","https://media.gemworkers.com/items/643e2426-a20f-4c78-a46a-b562aa186ca8/etsy-8.jpg","https://media.gemworkers.com/items/643e2426-a20f-4c78-a46a-b562aa186ca8/etsy-9.jpg","https://media.gemworkers.com/items/643e2426-a20f-4c78-a46a-b562aa186ca8/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 500 USD, converted at ECB rate. Etsy tags: Rings for women,natural stone,gift for her,jewellery making,jewellery supplies,jewellery findings,bicolour tourmaline,pink tourmaline,stud jewellery,tourmaline emerald,emerald cut,green tourmaline,Watermelon Tourmalin.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('8f3b1e6d-b57a-4b29-ae5d-4bdc1a6a5f74', '11 Cts Lagoon Tourmaline Lot', 'Gorgeous Top Lagoon Colour Tourmaline Lot

Exceptional Colour Very Rare To Be Find, Bright Colour Not Dull.

More Beautiful In Real.

11 Cts
5 to 10mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 402, 1, 'loose_stone', 'Tourmaline', NULL, 11, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/8f3b1e6d-b57a-4b29-ae5d-4bdc1a6a5f74/etsy-1.jpg","https://media.gemworkers.com/items/8f3b1e6d-b57a-4b29-ae5d-4bdc1a6a5f74/etsy-2.jpg","https://media.gemworkers.com/items/8f3b1e6d-b57a-4b29-ae5d-4bdc1a6a5f74/etsy-3.jpg","https://media.gemworkers.com/items/8f3b1e6d-b57a-4b29-ae5d-4bdc1a6a5f74/etsy-4.jpg","https://media.gemworkers.com/items/8f3b1e6d-b57a-4b29-ae5d-4bdc1a6a5f74/etsy-5.jpg","https://media.gemworkers.com/items/8f3b1e6d-b57a-4b29-ae5d-4bdc1a6a5f74/etsy-6.jpg","https://media.gemworkers.com/items/8f3b1e6d-b57a-4b29-ae5d-4bdc1a6a5f74/etsy-7.jpg","https://media.gemworkers.com/items/8f3b1e6d-b57a-4b29-ae5d-4bdc1a6a5f74/etsy-8.jpg","https://media.gemworkers.com/items/8f3b1e6d-b57a-4b29-ae5d-4bdc1a6a5f74/etsy-9.jpg","https://media.gemworkers.com/items/8f3b1e6d-b57a-4b29-ae5d-4bdc1a6a5f74/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 450 USD, converted at ECB rate. Etsy tags: Paraiba Tourmaline,Paraiba Colour,Lagoon Tourmaline,Bluegreen Tourmaline,Blue Tourmaline,Neon Blue Tourmaline,Tourmaline Jewellery,Jewellers,Lagoon Colour,Oceangemsminerals,Ink Blue Tourmaline,Wedding Rings,Rings For Women.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('04e00bf6-d9c8-4bcb-b1e8-490fbd4dede5', '7 Cts Watermelon Tourmaline Lot', 'Sweet Bicolour Tourmaline

Unique And Rare Colour

7 Cts
7.5 to 4.9mm

No treatment.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 322, 1, 'loose_stone', 'Tourmaline', 'Watermelon', 7, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/04e00bf6-d9c8-4bcb-b1e8-490fbd4dede5/etsy-1.jpg","https://media.gemworkers.com/items/04e00bf6-d9c8-4bcb-b1e8-490fbd4dede5/etsy-2.jpg","https://media.gemworkers.com/items/04e00bf6-d9c8-4bcb-b1e8-490fbd4dede5/etsy-3.jpg","https://media.gemworkers.com/items/04e00bf6-d9c8-4bcb-b1e8-490fbd4dede5/etsy-4.jpg","https://media.gemworkers.com/items/04e00bf6-d9c8-4bcb-b1e8-490fbd4dede5/etsy-5.jpg","https://media.gemworkers.com/items/04e00bf6-d9c8-4bcb-b1e8-490fbd4dede5/etsy-6.jpg","https://media.gemworkers.com/items/04e00bf6-d9c8-4bcb-b1e8-490fbd4dede5/etsy-7.jpg","https://media.gemworkers.com/items/04e00bf6-d9c8-4bcb-b1e8-490fbd4dede5/etsy-8.jpg","https://media.gemworkers.com/items/04e00bf6-d9c8-4bcb-b1e8-490fbd4dede5/etsy-9.jpg","https://media.gemworkers.com/items/04e00bf6-d9c8-4bcb-b1e8-490fbd4dede5/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 360 USD, converted at ECB rate. Etsy tags: Tourmaline Jewellery,Tourmaline Earrings,Earrings Stud,y2k earrings stud,Gold Rings,Natural Stone,Gift For Her,Rings For Men,Oceangemsminerals,lagoon tourmaline,tourmaline pairs,bicolour tourmaline,Watermelon Bicolour.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('f06ab94a-478a-441a-9221-8d6512e7f1fa', '18.4 Cts Green Tourmalines', 'Green Afghan Tourmalines

18.4 Cts
11.8 to 5.8mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 447, 1, 'loose_stone', 'Tourmaline', NULL, 18.4, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/f06ab94a-478a-441a-9221-8d6512e7f1fa/etsy-1.jpg","https://media.gemworkers.com/items/f06ab94a-478a-441a-9221-8d6512e7f1fa/etsy-2.jpg","https://media.gemworkers.com/items/f06ab94a-478a-441a-9221-8d6512e7f1fa/etsy-3.jpg","https://media.gemworkers.com/items/f06ab94a-478a-441a-9221-8d6512e7f1fa/etsy-4.jpg","https://media.gemworkers.com/items/f06ab94a-478a-441a-9221-8d6512e7f1fa/etsy-5.jpg","https://media.gemworkers.com/items/f06ab94a-478a-441a-9221-8d6512e7f1fa/etsy-6.jpg","https://media.gemworkers.com/items/f06ab94a-478a-441a-9221-8d6512e7f1fa/etsy-7.jpg","https://media.gemworkers.com/items/f06ab94a-478a-441a-9221-8d6512e7f1fa/etsy-8.jpg","https://media.gemworkers.com/items/f06ab94a-478a-441a-9221-8d6512e7f1fa/etsy-9.jpg","https://media.gemworkers.com/items/f06ab94a-478a-441a-9221-8d6512e7f1fa/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 500 USD, converted at ECB rate. Etsy tags: Paraiba Tourmaline,Paraiba Colour,Lagoon Tourmaline,Bluegreen Tourmaline,Blue Tourmaline,Neon Blue Tourmaline,Tourmaline Jewellery,Lagoon Colour,Oceangemsminerals,Ink Blue Tourmaline,Wedding Rings,Rings For Women,Cushion Cut.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('d80346ff-92c9-4b57-8483-9ce227591748', '5.10Cts, Seafoam Tourmalines', 'Gorgeous Seafoam And blue Colour Tourmaline Lot

Weight:5.10 carats 
Size:5mm to 10mm long

Untreated, Unheated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 89, 1, 'loose_stone', 'Tourmaline', NULL, 5.1, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/d80346ff-92c9-4b57-8483-9ce227591748/etsy-1.jpg","https://media.gemworkers.com/items/d80346ff-92c9-4b57-8483-9ce227591748/etsy-2.jpg","https://media.gemworkers.com/items/d80346ff-92c9-4b57-8483-9ce227591748/etsy-3.jpg","https://media.gemworkers.com/items/d80346ff-92c9-4b57-8483-9ce227591748/etsy-4.jpg","https://media.gemworkers.com/items/d80346ff-92c9-4b57-8483-9ce227591748/etsy-5.jpg","https://media.gemworkers.com/items/d80346ff-92c9-4b57-8483-9ce227591748/etsy-6.jpg","https://media.gemworkers.com/items/d80346ff-92c9-4b57-8483-9ce227591748/etsy-7.jpg","https://media.gemworkers.com/items/d80346ff-92c9-4b57-8483-9ce227591748/etsy-8.jpg","https://media.gemworkers.com/items/d80346ff-92c9-4b57-8483-9ce227591748/etsy-9.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 100 USD, converted at ECB rate. Etsy tags: Jewellery making,Jewellery supplies,Jewellery findings,Natural stone,Y2k earrings stud,Hoop earrings,Gift for her,Handmadejewellery,Jewels,seafoam tourmaline,mint tourmaline,green tourmaline,lagoon tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('e07d4765-f339-4e16-a3f6-dd003efddd38', '3.80 Cts Bicolour Tourmaline', 'Natural Rare Bicolour mesmerising tourmaline 

3.80 Cts
10.6 x 7.8 x 5.2mm

unheated,', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 264, 1, 'loose_stone', 'Tourmaline', NULL, 3.8, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/e07d4765-f339-4e16-a3f6-dd003efddd38/etsy-1.jpg","https://media.gemworkers.com/items/e07d4765-f339-4e16-a3f6-dd003efddd38/etsy-2.jpg","https://media.gemworkers.com/items/e07d4765-f339-4e16-a3f6-dd003efddd38/etsy-3.jpg","https://media.gemworkers.com/items/e07d4765-f339-4e16-a3f6-dd003efddd38/etsy-4.jpg","https://media.gemworkers.com/items/e07d4765-f339-4e16-a3f6-dd003efddd38/etsy-5.jpg","https://media.gemworkers.com/items/e07d4765-f339-4e16-a3f6-dd003efddd38/etsy-6.jpg","https://media.gemworkers.com/items/e07d4765-f339-4e16-a3f6-dd003efddd38/etsy-7.jpg","https://media.gemworkers.com/items/e07d4765-f339-4e16-a3f6-dd003efddd38/etsy-8.jpg","https://media.gemworkers.com/items/e07d4765-f339-4e16-a3f6-dd003efddd38/etsy-9.jpg","https://media.gemworkers.com/items/e07d4765-f339-4e16-a3f6-dd003efddd38/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 295 USD, converted at ECB rate. Etsy tags: Rings for women,natural stone,gift for her,jewellery making,jewellery supplies,jewellery findings,bicolour tourmaline,pink tourmaline,stud jewellery,tourmaline emerald,emerald cut,green tourmaline,Watermelon Tourmalin.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('a23e7ff2-d92d-4442-9787-ea097d802d5c', '3 Cts Chrome Green Tourmaline', 'Gorgeous Mesmerising Chrome Green Cool Colour Afghan Tourmaline 

One Of A Kind

3.00 Cts
9 x 8.8 x 6.5mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 268, 1, 'loose_stone', 'Tourmaline', NULL, 3, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/a23e7ff2-d92d-4442-9787-ea097d802d5c/etsy-1.jpg","https://media.gemworkers.com/items/a23e7ff2-d92d-4442-9787-ea097d802d5c/etsy-2.jpg","https://media.gemworkers.com/items/a23e7ff2-d92d-4442-9787-ea097d802d5c/etsy-3.jpg","https://media.gemworkers.com/items/a23e7ff2-d92d-4442-9787-ea097d802d5c/etsy-4.jpg","https://media.gemworkers.com/items/a23e7ff2-d92d-4442-9787-ea097d802d5c/etsy-5.jpg","https://media.gemworkers.com/items/a23e7ff2-d92d-4442-9787-ea097d802d5c/etsy-6.jpg","https://media.gemworkers.com/items/a23e7ff2-d92d-4442-9787-ea097d802d5c/etsy-7.jpg","https://media.gemworkers.com/items/a23e7ff2-d92d-4442-9787-ea097d802d5c/etsy-8.jpg","https://media.gemworkers.com/items/a23e7ff2-d92d-4442-9787-ea097d802d5c/etsy-9.jpg","https://media.gemworkers.com/items/a23e7ff2-d92d-4442-9787-ea097d802d5c/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 300 USD, converted at ECB rate. Etsy tags: Tourmaline Jewellery,Jewellery Supplies,Jewellery Making,Jewellery Findings,Tourmaline Earrings,Earrings Stud,y2k earrings stud,Gold Rings,Natural Stone,Gift For Her,Rings For Men,Rings For Women,Chrome Tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('d1095cae-27ad-4a85-943a-c970ab4cf219', '9.25 Cts Bicolour Tourmaline', 'Bicolour Blue Mesmerising Afghan Tourmaline 

9.25 Cts
13.5 x 9.1 x 7.7mm

unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 165, 1, 'loose_stone', 'Tourmaline', NULL, 9.25, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/d1095cae-27ad-4a85-943a-c970ab4cf219/etsy-1.jpg","https://media.gemworkers.com/items/d1095cae-27ad-4a85-943a-c970ab4cf219/etsy-2.jpg","https://media.gemworkers.com/items/d1095cae-27ad-4a85-943a-c970ab4cf219/etsy-3.jpg","https://media.gemworkers.com/items/d1095cae-27ad-4a85-943a-c970ab4cf219/etsy-4.jpg","https://media.gemworkers.com/items/d1095cae-27ad-4a85-943a-c970ab4cf219/etsy-5.jpg","https://media.gemworkers.com/items/d1095cae-27ad-4a85-943a-c970ab4cf219/etsy-6.jpg","https://media.gemworkers.com/items/d1095cae-27ad-4a85-943a-c970ab4cf219/etsy-7.jpg","https://media.gemworkers.com/items/d1095cae-27ad-4a85-943a-c970ab4cf219/etsy-8.jpg","https://media.gemworkers.com/items/d1095cae-27ad-4a85-943a-c970ab4cf219/etsy-9.jpg","https://media.gemworkers.com/items/d1095cae-27ad-4a85-943a-c970ab4cf219/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 185 USD, converted at ECB rate. Etsy tags: Bicolour Tourmaline,Blue Tourmaline,Lagoon Tourmaline,Neon Tourmaline,Tourmaline jewellery,gift for her,natural stone,Tourmaline Rings,tourmaline necklace,rings for men,rings for women,jewellery making,jewellery supplies.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('c55de4ff-a286-4da6-8067-1f2ba0e349ee', '3.20 Cts Lagoon Colour Tourmalines', 'Gorgeous Ice Blue Or Lagoon Tourmalines 

3.20 Cts
6.5x6.5x4.4mm
7.3x5.6x4.5mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 357, 1, 'loose_stone', 'Tourmaline', NULL, 3.2, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/c55de4ff-a286-4da6-8067-1f2ba0e349ee/etsy-1.jpg","https://media.gemworkers.com/items/c55de4ff-a286-4da6-8067-1f2ba0e349ee/etsy-2.jpg","https://media.gemworkers.com/items/c55de4ff-a286-4da6-8067-1f2ba0e349ee/etsy-3.jpg","https://media.gemworkers.com/items/c55de4ff-a286-4da6-8067-1f2ba0e349ee/etsy-4.jpg","https://media.gemworkers.com/items/c55de4ff-a286-4da6-8067-1f2ba0e349ee/etsy-5.jpg","https://media.gemworkers.com/items/c55de4ff-a286-4da6-8067-1f2ba0e349ee/etsy-6.jpg","https://media.gemworkers.com/items/c55de4ff-a286-4da6-8067-1f2ba0e349ee/etsy-7.jpg","https://media.gemworkers.com/items/c55de4ff-a286-4da6-8067-1f2ba0e349ee/etsy-8.jpg","https://media.gemworkers.com/items/c55de4ff-a286-4da6-8067-1f2ba0e349ee/etsy-9.jpg","https://media.gemworkers.com/items/c55de4ff-a286-4da6-8067-1f2ba0e349ee/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 400 USD, converted at ECB rate. Etsy tags: Paraiba Tourmaline,Paraiba Colour,Lagoon Tourmaline,Bluegreen Tourmaline,Blue Tourmaline,Neon Blue Tourmaline,Tourmaline Jewellery,Jewellers,Lagoon Colour,Oceangemsminerals,Ink Blue Tourmaline,Wedding Rings,Rings For Women.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('34b4834b-92d6-4b58-83c4-c81d32709e2d', '8.15 Cts Lagoon Green Colour Tourmaline', 'Mesmerising Lagoon Green Colour Afghan Tourmaline 

Ethically sourced, 

8.15 Cts
5 to 12mm

Unheated, Untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 313, 1, 'loose_stone', 'Tourmaline', NULL, 8.15, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/34b4834b-92d6-4b58-83c4-c81d32709e2d/etsy-1.jpg","https://media.gemworkers.com/items/34b4834b-92d6-4b58-83c4-c81d32709e2d/etsy-2.jpg","https://media.gemworkers.com/items/34b4834b-92d6-4b58-83c4-c81d32709e2d/etsy-3.jpg","https://media.gemworkers.com/items/34b4834b-92d6-4b58-83c4-c81d32709e2d/etsy-4.jpg","https://media.gemworkers.com/items/34b4834b-92d6-4b58-83c4-c81d32709e2d/etsy-5.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 350 USD, converted at ECB rate. Etsy tags: Bluegreen Tourmaline,Blue Tourmaline,Green Tourmaline,Jewellery supplies,jewellery making,jewellery findings,jewels,Handmadejewellery,cushion cut,gift for her,natural stone,gold rings,silver stirring.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('c67c1731-cf14-4e6d-ab0a-6b4d5fb53af8', '2.9 Cts Lagoon Bicolour Tourmaline', 'Gorgeous Mesmerising Lagoon Bicolour Natural Afghanistan Tourmaline

More beautiful In real, One of a kind

2.90 Cts
31 x 3.2 x 3mm

unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 223, 1, 'loose_stone', 'Tourmaline', NULL, 2.9, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/c67c1731-cf14-4e6d-ab0a-6b4d5fb53af8/etsy-1.jpg","https://media.gemworkers.com/items/c67c1731-cf14-4e6d-ab0a-6b4d5fb53af8/etsy-2.jpg","https://media.gemworkers.com/items/c67c1731-cf14-4e6d-ab0a-6b4d5fb53af8/etsy-3.jpg","https://media.gemworkers.com/items/c67c1731-cf14-4e6d-ab0a-6b4d5fb53af8/etsy-4.jpg","https://media.gemworkers.com/items/c67c1731-cf14-4e6d-ab0a-6b4d5fb53af8/etsy-5.jpg","https://media.gemworkers.com/items/c67c1731-cf14-4e6d-ab0a-6b4d5fb53af8/etsy-6.jpg","https://media.gemworkers.com/items/c67c1731-cf14-4e6d-ab0a-6b4d5fb53af8/etsy-7.jpg","https://media.gemworkers.com/items/c67c1731-cf14-4e6d-ab0a-6b4d5fb53af8/etsy-8.jpg","https://media.gemworkers.com/items/c67c1731-cf14-4e6d-ab0a-6b4d5fb53af8/etsy-9.jpg","https://media.gemworkers.com/items/c67c1731-cf14-4e6d-ab0a-6b4d5fb53af8/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 250 USD, converted at ECB rate. Etsy tags: Jewellery Supplies,Jewellery Making,Gold Rings,Rings For Men,Rings For Women,y2k earrings stud,Gift For Her,Tourmaline Jewellery,Natural Stone,Stud Earrings,Jewellery Stud,bicolour Tourmaline,Lagoon tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('2a464afa-a1ea-4901-85eb-786b5e8e5f63', '3.55 Cts Pink Bicolour Tourmaline', 'Natural Pink bicolour mesmerising tourmaline 

3.55 cts 

6.4 x 6.7 x 4.9 mm
6.3 x 5.8 x 4.9 mm


unheated, untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 447, 1, 'loose_stone', 'Tourmaline', NULL, 3.55, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/2a464afa-a1ea-4901-85eb-786b5e8e5f63/etsy-1.jpg","https://media.gemworkers.com/items/2a464afa-a1ea-4901-85eb-786b5e8e5f63/etsy-2.jpg","https://media.gemworkers.com/items/2a464afa-a1ea-4901-85eb-786b5e8e5f63/etsy-3.jpg","https://media.gemworkers.com/items/2a464afa-a1ea-4901-85eb-786b5e8e5f63/etsy-4.jpg","https://media.gemworkers.com/items/2a464afa-a1ea-4901-85eb-786b5e8e5f63/etsy-5.jpg","https://media.gemworkers.com/items/2a464afa-a1ea-4901-85eb-786b5e8e5f63/etsy-6.jpg","https://media.gemworkers.com/items/2a464afa-a1ea-4901-85eb-786b5e8e5f63/etsy-7.jpg","https://media.gemworkers.com/items/2a464afa-a1ea-4901-85eb-786b5e8e5f63/etsy-8.jpg","https://media.gemworkers.com/items/2a464afa-a1ea-4901-85eb-786b5e8e5f63/etsy-9.jpg","https://media.gemworkers.com/items/2a464afa-a1ea-4901-85eb-786b5e8e5f63/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 500 USD, converted at ECB rate. Etsy tags: Rings for women,rings for men,natural stone,gift for her,jewellery making,jewellery supplies,jewellery findings,bicolour tourmaline,pink tourmaline,stud jewellery,tourmaline emerald,emerald cut,green tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('08f9b5e6-32ce-4da5-9d00-a982d4dc9b72', '5 Cts, Natural Watermelon Bicolour Afghan Tourmaline', 'Gorgeous Mesmerising Natural Watermelon Bicolour Afghan Tourmalines

high lustre, Saturated Colour.

5 cts

Size:6.1 x 4.2 x  4.1mm
10.2 x 4.1 x 2.9 mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 313, 1, 'loose_stone', 'Tourmaline', 'Watermelon', 5, 'ct', 'Afghanistan', NULL, '6.1 x 4.2 x  4.1', '["https://media.gemworkers.com/items/08f9b5e6-32ce-4da5-9d00-a982d4dc9b72/etsy-1.jpg","https://media.gemworkers.com/items/08f9b5e6-32ce-4da5-9d00-a982d4dc9b72/etsy-2.jpg","https://media.gemworkers.com/items/08f9b5e6-32ce-4da5-9d00-a982d4dc9b72/etsy-3.jpg","https://media.gemworkers.com/items/08f9b5e6-32ce-4da5-9d00-a982d4dc9b72/etsy-4.jpg","https://media.gemworkers.com/items/08f9b5e6-32ce-4da5-9d00-a982d4dc9b72/etsy-5.jpg","https://media.gemworkers.com/items/08f9b5e6-32ce-4da5-9d00-a982d4dc9b72/etsy-6.jpg","https://media.gemworkers.com/items/08f9b5e6-32ce-4da5-9d00-a982d4dc9b72/etsy-7.jpg","https://media.gemworkers.com/items/08f9b5e6-32ce-4da5-9d00-a982d4dc9b72/etsy-8.jpg","https://media.gemworkers.com/items/08f9b5e6-32ce-4da5-9d00-a982d4dc9b72/etsy-9.jpg","https://media.gemworkers.com/items/08f9b5e6-32ce-4da5-9d00-a982d4dc9b72/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 350 USD, converted at ECB rate. Etsy tags: Tourmaline Rings,rings for women,rings for men,jewellery making,jewellery findings,gift for her,natural stone,Oceangemsminerals,apple green colour,Bicolour Tourmaline,Natural Bicolour,Unheated Tourmaline,Lipstick Tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('8edb37e6-16a8-4fb1-907d-2cc0018dc1ea', '11.9 Cts, 5 Peridot pairs', 'bright Colour Peridot Pairs

origin- pakistan 

pakistan peridot is one of the finest and top quality 

11.90 Cts
4.8 to 7mm

unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 179, 1, 'loose_stone', 'Peridot', NULL, 11.9, 'ct', 'Pakistan', NULL, NULL, '["https://media.gemworkers.com/items/8edb37e6-16a8-4fb1-907d-2cc0018dc1ea/etsy-1.jpg","https://media.gemworkers.com/items/8edb37e6-16a8-4fb1-907d-2cc0018dc1ea/etsy-2.jpg","https://media.gemworkers.com/items/8edb37e6-16a8-4fb1-907d-2cc0018dc1ea/etsy-3.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 200 USD, converted at ECB rate. Etsy tags: jewellery making,jewellery supplies,jewellery findings,loose gemstones,gift for her,peridot pairs,peridot jewellery,pakistan peridot,green peridot,trillion peridot,y2k earrings stud,necklace findings,gold rings.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('cc26e71a-5c7c-414a-b8b2-14b8a392b9f9', '10 Cts, 5 Peridot pairs', 'bright Colour Peridot Pairs

origin- pakistan 

pakistan peridot is one of the finest and top quality 

10.20 Cts
5.7 to 7mm

unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 179, 1, 'loose_stone', 'Peridot', NULL, 10, 'ct', 'Pakistan', NULL, NULL, '["https://media.gemworkers.com/items/cc26e71a-5c7c-414a-b8b2-14b8a392b9f9/etsy-1.jpg","https://media.gemworkers.com/items/cc26e71a-5c7c-414a-b8b2-14b8a392b9f9/etsy-2.jpg","https://media.gemworkers.com/items/cc26e71a-5c7c-414a-b8b2-14b8a392b9f9/etsy-3.jpg","https://media.gemworkers.com/items/cc26e71a-5c7c-414a-b8b2-14b8a392b9f9/etsy-4.jpg","https://media.gemworkers.com/items/cc26e71a-5c7c-414a-b8b2-14b8a392b9f9/etsy-5.jpg","https://media.gemworkers.com/items/cc26e71a-5c7c-414a-b8b2-14b8a392b9f9/etsy-6.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 200 USD, converted at ECB rate. Etsy tags: jewellery making,jewellery supplies,jewellery findings,loose gemstones,gift for her,peridot pairs,peridot jewellery,pakistan peridot,green peridot,trillion peridot,y2k earrings stud,necklace findings,gold rings.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('eeea097c-c560-4e76-9fac-21056843e0dc', '12.5 Cts Ascher Cut Peridot Lot', 'bright Colour Peridot Lot

origin- pakistan 

pakistan peridot is one of the finest and top quality 

Ascher Cuts

12.50 Cts
5.3 to 3.9mm

unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 134, 1, 'loose_stone', 'Peridot', NULL, 12.5, 'ct', 'Pakistan', NULL, NULL, '["https://media.gemworkers.com/items/eeea097c-c560-4e76-9fac-21056843e0dc/etsy-1.jpg","https://media.gemworkers.com/items/eeea097c-c560-4e76-9fac-21056843e0dc/etsy-2.jpg","https://media.gemworkers.com/items/eeea097c-c560-4e76-9fac-21056843e0dc/etsy-3.jpg","https://media.gemworkers.com/items/eeea097c-c560-4e76-9fac-21056843e0dc/etsy-4.jpg","https://media.gemworkers.com/items/eeea097c-c560-4e76-9fac-21056843e0dc/etsy-5.jpg","https://media.gemworkers.com/items/eeea097c-c560-4e76-9fac-21056843e0dc/etsy-6.jpg","https://media.gemworkers.com/items/eeea097c-c560-4e76-9fac-21056843e0dc/etsy-7.jpg","https://media.gemworkers.com/items/eeea097c-c560-4e76-9fac-21056843e0dc/etsy-8.jpg","https://media.gemworkers.com/items/eeea097c-c560-4e76-9fac-21056843e0dc/etsy-9.jpg","https://media.gemworkers.com/items/eeea097c-c560-4e76-9fac-21056843e0dc/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 150 USD, converted at ECB rate. Etsy tags: jewellery making,jewellery supplies,jewellery findings,loose gemstones,gift for her,peridot pairs,peridot jewellery,pakistan peridot,green peridot,trillion peridot,y2k earrings stud,necklace findings,gold rings.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('52c3b230-71e0-4b83-ae73-3c6e06bd605a', 'Top Pink Bicolour Tourmaline, 12.90 Cts', 'mesmerising baby pink bicolour tourmaline 

best for necklace and ring. or buy it for collection it’s a rare piece the pink colour is very gorgeous.

12.90 Cts
15 x 12.5 x 8mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 268, 1, 'loose_stone', 'Tourmaline', NULL, 12.9, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/52c3b230-71e0-4b83-ae73-3c6e06bd605a/etsy-1.jpg","https://media.gemworkers.com/items/52c3b230-71e0-4b83-ae73-3c6e06bd605a/etsy-2.jpg","https://media.gemworkers.com/items/52c3b230-71e0-4b83-ae73-3c6e06bd605a/etsy-3.jpg","https://media.gemworkers.com/items/52c3b230-71e0-4b83-ae73-3c6e06bd605a/etsy-4.jpg","https://media.gemworkers.com/items/52c3b230-71e0-4b83-ae73-3c6e06bd605a/etsy-5.jpg","https://media.gemworkers.com/items/52c3b230-71e0-4b83-ae73-3c6e06bd605a/etsy-6.jpg","https://media.gemworkers.com/items/52c3b230-71e0-4b83-ae73-3c6e06bd605a/etsy-7.jpg","https://media.gemworkers.com/items/52c3b230-71e0-4b83-ae73-3c6e06bd605a/etsy-8.jpg","https://media.gemworkers.com/items/52c3b230-71e0-4b83-ae73-3c6e06bd605a/etsy-9.jpg","https://media.gemworkers.com/items/52c3b230-71e0-4b83-ae73-3c6e06bd605a/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 300 USD, converted at ECB rate. Etsy tags: Emerald Cut,Bicolour Tourmaline,Tricolour Tourmaline,Pink Bicolour,Unheated,Tourmaline jewellery,Natural Stone,Gift For Her,Blue tourmalines,Green Tourmaline,Rings For Men,Gold Rings,Stud Jewellery.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('8ec50922-4610-4b67-ab7e-310f70d065aa', '4.25 Cts Reverse Tourmaline Pair', 'tourmaline Reverse Pair

top colour high lustre and brilliance 

4.25 Cts
5.5 x 5.4 x 4mm
6 x 6 x 4.5mm

100% natural no treatment whatsoever.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 759, 1, 'loose_stone', 'Tourmaline', NULL, 4.25, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/8ec50922-4610-4b67-ab7e-310f70d065aa/etsy-1.jpg","https://media.gemworkers.com/items/8ec50922-4610-4b67-ab7e-310f70d065aa/etsy-2.jpg","https://media.gemworkers.com/items/8ec50922-4610-4b67-ab7e-310f70d065aa/etsy-3.jpg","https://media.gemworkers.com/items/8ec50922-4610-4b67-ab7e-310f70d065aa/etsy-4.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 850 USD, converted at ECB rate. Etsy tags: Natural Stone,Jewellery Supplies,Jewellery Making,Jewellery Findings,y2k stud earrings,Gift For Her,Rings For Men,Rings For Women,Gold Rings,Silver Sterling,Garnet Necklace,Garnet Rings,Garnet Jewellery.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('a9cb6266-db00-488a-8e24-7f1ca93d0736', 'Pink And Olive Green Tourmaline Lot 9.85 Cts', 'A Mesmerising Tourmaline Lot, with olive green and pink colour tourmaline 

9.85 Cts
average sizes 
8.5 x 5.5 x 3.5mm
5.5 x 5 x 5mm

no treatment.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 134, 1, 'loose_stone', 'Tourmaline', NULL, 9.85, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/a9cb6266-db00-488a-8e24-7f1ca93d0736/etsy-1.jpg","https://media.gemworkers.com/items/a9cb6266-db00-488a-8e24-7f1ca93d0736/etsy-2.jpg","https://media.gemworkers.com/items/a9cb6266-db00-488a-8e24-7f1ca93d0736/etsy-3.jpg","https://media.gemworkers.com/items/a9cb6266-db00-488a-8e24-7f1ca93d0736/etsy-4.jpg","https://media.gemworkers.com/items/a9cb6266-db00-488a-8e24-7f1ca93d0736/etsy-5.jpg","https://media.gemworkers.com/items/a9cb6266-db00-488a-8e24-7f1ca93d0736/etsy-6.jpg","https://media.gemworkers.com/items/a9cb6266-db00-488a-8e24-7f1ca93d0736/etsy-7.jpg","https://media.gemworkers.com/items/a9cb6266-db00-488a-8e24-7f1ca93d0736/etsy-8.jpg","https://media.gemworkers.com/items/a9cb6266-db00-488a-8e24-7f1ca93d0736/etsy-9.jpg","https://media.gemworkers.com/items/a9cb6266-db00-488a-8e24-7f1ca93d0736/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 150 USD, converted at ECB rate. Etsy tags: Emerald Cut,Bicolour Tourmaline,Watermelon Bicolour,Tourmaline Jewellery,Jewellery Supplies,Jewellery Making,Jewellery Findings,y2k earrings stud,Gift For Her,Gold Rings,Rings For Men,Rings For Women,Natural Stone.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('180c0993-6ebe-4c70-83e8-226f7f87f45d', '2.75 Cts Neon Blue Bicolour Tourmaline', 'Top Quality Neon Blue Bicolour Tourmaline Emerald Cut 

rare find

2.75 Cts
17 to 12mm

No Treatment Whatsoever.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 188, 1, 'loose_stone', 'Tourmaline', NULL, 2.75, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/180c0993-6ebe-4c70-83e8-226f7f87f45d/etsy-1.jpg","https://media.gemworkers.com/items/180c0993-6ebe-4c70-83e8-226f7f87f45d/etsy-2.jpg","https://media.gemworkers.com/items/180c0993-6ebe-4c70-83e8-226f7f87f45d/etsy-3.jpg","https://media.gemworkers.com/items/180c0993-6ebe-4c70-83e8-226f7f87f45d/etsy-4.jpg","https://media.gemworkers.com/items/180c0993-6ebe-4c70-83e8-226f7f87f45d/etsy-5.jpg","https://media.gemworkers.com/items/180c0993-6ebe-4c70-83e8-226f7f87f45d/etsy-6.jpg","https://media.gemworkers.com/items/180c0993-6ebe-4c70-83e8-226f7f87f45d/etsy-7.jpg","https://media.gemworkers.com/items/180c0993-6ebe-4c70-83e8-226f7f87f45d/etsy-8.jpg","https://media.gemworkers.com/items/180c0993-6ebe-4c70-83e8-226f7f87f45d/etsy-9.jpg","https://media.gemworkers.com/items/180c0993-6ebe-4c70-83e8-226f7f87f45d/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 210 USD, converted at ECB rate. Etsy tags: Emerald Cut,EmeraldCutTourmaline,Jewellery making,earrings stud,Tourmaline Lot,Blue Tourmaline,Lagoon Tourmaline,Neon Blue,neon blue tourmaline,Rings For Men,Tourmalines,Ink Blue Tourmaline,Oceangemsminerals.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('bec01db4-7779-44f7-b75c-bd44afa5c841', '1.30 Cts Ink Blue Tourmaline Earring’s Set', 'Top Colour Ink Blue Colour Tourmaline Beautiful Cut Earrings Set

rare find

Bright And Open Colour

1.30 Cts
5.8 to 8.3mm

No Treatment Whatsoever.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 223, 1, 'jewelry', 'Tourmaline', NULL, 1.3, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/bec01db4-7779-44f7-b75c-bd44afa5c841/etsy-1.jpg","https://media.gemworkers.com/items/bec01db4-7779-44f7-b75c-bd44afa5c841/etsy-2.jpg","https://media.gemworkers.com/items/bec01db4-7779-44f7-b75c-bd44afa5c841/etsy-3.jpg","https://media.gemworkers.com/items/bec01db4-7779-44f7-b75c-bd44afa5c841/etsy-4.jpg","https://media.gemworkers.com/items/bec01db4-7779-44f7-b75c-bd44afa5c841/etsy-5.jpg","https://media.gemworkers.com/items/bec01db4-7779-44f7-b75c-bd44afa5c841/etsy-6.jpg","https://media.gemworkers.com/items/bec01db4-7779-44f7-b75c-bd44afa5c841/etsy-7.jpg","https://media.gemworkers.com/items/bec01db4-7779-44f7-b75c-bd44afa5c841/etsy-8.jpg","https://media.gemworkers.com/items/bec01db4-7779-44f7-b75c-bd44afa5c841/etsy-9.jpg","https://media.gemworkers.com/items/bec01db4-7779-44f7-b75c-bd44afa5c841/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 250 USD, converted at ECB rate. Etsy tags: Emerald Cut,EmeraldCutTourmaline,Jewellery making,earrings stud,Tourmaline Lot,Blue Tourmaline,Lagoon Tourmaline,Neon Blue,neon blue tourmaline,Rings For Men,Tourmalines,Ink Blue Tourmaline,Oceangemsminerals.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('d9517f65-c496-4a89-850a-9ec63dfb1a0e', '1+ Cts Ink Blue Tourmaline Earring’s Set', 'Top Colour Ink Blue Colour Tourmaline Beautiful Cut Earrings Set

rare find

Bright And Open Colour

1+ Cts
5.2 to 9mm

No Treatment Whatsoever.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 223, 1, 'jewelry', 'Tourmaline', NULL, NULL, NULL, NULL, NULL, NULL, '["https://media.gemworkers.com/items/d9517f65-c496-4a89-850a-9ec63dfb1a0e/etsy-1.jpg","https://media.gemworkers.com/items/d9517f65-c496-4a89-850a-9ec63dfb1a0e/etsy-2.jpg","https://media.gemworkers.com/items/d9517f65-c496-4a89-850a-9ec63dfb1a0e/etsy-3.jpg","https://media.gemworkers.com/items/d9517f65-c496-4a89-850a-9ec63dfb1a0e/etsy-4.jpg","https://media.gemworkers.com/items/d9517f65-c496-4a89-850a-9ec63dfb1a0e/etsy-5.jpg","https://media.gemworkers.com/items/d9517f65-c496-4a89-850a-9ec63dfb1a0e/etsy-6.jpg","https://media.gemworkers.com/items/d9517f65-c496-4a89-850a-9ec63dfb1a0e/etsy-7.jpg","https://media.gemworkers.com/items/d9517f65-c496-4a89-850a-9ec63dfb1a0e/etsy-8.jpg","https://media.gemworkers.com/items/d9517f65-c496-4a89-850a-9ec63dfb1a0e/etsy-9.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 250 USD, converted at ECB rate. Etsy tags: Emerald Cut,EmeraldCutTourmaline,Jewellery making,earrings stud,Tourmaline Lot,Blue Tourmaline,Lagoon Tourmaline,Neon Blue,neon blue tourmaline,Rings For Men,Tourmalines,Ink Blue Tourmaline,Oceangemsminerals.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('8e511db4-bdc1-4649-afe5-d947f3d34218', '2.4 Cts Ink Blue Tourmaline Earring’s Set', 'Top Colour Ink Blue Colour Tourmaline Beautiful Cut Earrings Set

rare find

Bright And Open Colour

2.40 Cts
4.5 to 10.5mm

No Treatment Whatsoever.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 268, 1, 'jewelry', 'Tourmaline', NULL, 2.4, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/8e511db4-bdc1-4649-afe5-d947f3d34218/etsy-1.jpg","https://media.gemworkers.com/items/8e511db4-bdc1-4649-afe5-d947f3d34218/etsy-2.jpg","https://media.gemworkers.com/items/8e511db4-bdc1-4649-afe5-d947f3d34218/etsy-3.jpg","https://media.gemworkers.com/items/8e511db4-bdc1-4649-afe5-d947f3d34218/etsy-4.jpg","https://media.gemworkers.com/items/8e511db4-bdc1-4649-afe5-d947f3d34218/etsy-5.jpg","https://media.gemworkers.com/items/8e511db4-bdc1-4649-afe5-d947f3d34218/etsy-6.jpg","https://media.gemworkers.com/items/8e511db4-bdc1-4649-afe5-d947f3d34218/etsy-7.jpg","https://media.gemworkers.com/items/8e511db4-bdc1-4649-afe5-d947f3d34218/etsy-8.jpg","https://media.gemworkers.com/items/8e511db4-bdc1-4649-afe5-d947f3d34218/etsy-9.jpg","https://media.gemworkers.com/items/8e511db4-bdc1-4649-afe5-d947f3d34218/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 300 USD, converted at ECB rate. Etsy tags: Emerald Cut,EmeraldCutTourmaline,Jewellery making,earrings stud,Tourmaline Lot,Blue Tourmaline,Lagoon Tourmaline,Neon Blue,neon blue tourmaline,Rings For Men,Tourmalines,Ink Blue Tourmaline,Oceangemsminerals.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('400b86ca-ac40-4f1e-834f-9740ca531804', '2.55 Cts Baby Pink Tourmaline', 'mesmerising baby pink tourmaline 

Top Quality Fineest Colour

2.55 Cts 
9.7x6.3x4.6mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 446, 1, 'loose_stone', 'Tourmaline', NULL, 2.55, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/400b86ca-ac40-4f1e-834f-9740ca531804/etsy-1.jpg","https://media.gemworkers.com/items/400b86ca-ac40-4f1e-834f-9740ca531804/etsy-2.jpg","https://media.gemworkers.com/items/400b86ca-ac40-4f1e-834f-9740ca531804/etsy-3.jpg","https://media.gemworkers.com/items/400b86ca-ac40-4f1e-834f-9740ca531804/etsy-4.jpg","https://media.gemworkers.com/items/400b86ca-ac40-4f1e-834f-9740ca531804/etsy-5.jpg","https://media.gemworkers.com/items/400b86ca-ac40-4f1e-834f-9740ca531804/etsy-6.jpg","https://media.gemworkers.com/items/400b86ca-ac40-4f1e-834f-9740ca531804/etsy-7.jpg","https://media.gemworkers.com/items/400b86ca-ac40-4f1e-834f-9740ca531804/etsy-8.jpg","https://media.gemworkers.com/items/400b86ca-ac40-4f1e-834f-9740ca531804/etsy-9.jpg","https://media.gemworkers.com/items/400b86ca-ac40-4f1e-834f-9740ca531804/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 499 USD, converted at ECB rate. Etsy tags: Emerald Cut,Bicolour Tourmaline,Tricolour Tourmaline,Pink Bicolour,Unheated,Tourmaline jewellery,Natural Stone,Gift For Her,Blue tourmalines,Green Tourmaline,Rings For Men,Gold Rings,Stud Jewellery.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('4ea1b14f-690c-44e7-bfe0-8d9c72bff543', '3.2 Cts Paraiba Colour Tourmaline', 'Presenting One Of The Best Colour In Tourmalines

Paraiba Colour Tourmaline 

Exceptional Colour Very Rare To Be Find, Bright Colour Not Dull.

More Beautiful In Real.

3.20 Cts 
8.9x7.5x5.7mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 447, 1, 'loose_stone', 'Tourmaline', 'Paraiba', 3.2, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/4ea1b14f-690c-44e7-bfe0-8d9c72bff543/etsy-1.jpg","https://media.gemworkers.com/items/4ea1b14f-690c-44e7-bfe0-8d9c72bff543/etsy-2.jpg","https://media.gemworkers.com/items/4ea1b14f-690c-44e7-bfe0-8d9c72bff543/etsy-3.jpg","https://media.gemworkers.com/items/4ea1b14f-690c-44e7-bfe0-8d9c72bff543/etsy-4.jpg","https://media.gemworkers.com/items/4ea1b14f-690c-44e7-bfe0-8d9c72bff543/etsy-5.jpg","https://media.gemworkers.com/items/4ea1b14f-690c-44e7-bfe0-8d9c72bff543/etsy-6.jpg","https://media.gemworkers.com/items/4ea1b14f-690c-44e7-bfe0-8d9c72bff543/etsy-7.jpg","https://media.gemworkers.com/items/4ea1b14f-690c-44e7-bfe0-8d9c72bff543/etsy-8.jpg","https://media.gemworkers.com/items/4ea1b14f-690c-44e7-bfe0-8d9c72bff543/etsy-9.jpg","https://media.gemworkers.com/items/4ea1b14f-690c-44e7-bfe0-8d9c72bff543/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 500 USD, converted at ECB rate. Etsy tags: Paraiba Tourmaline,Paraiba Colour,Lagoon Tourmaline,Bluegreen Tourmaline,Blue Tourmaline,Neon Blue Tourmaline,Tourmaline Jewellery,Jewellers,Lagoon Colour,Oceangemsminerals,Ink Blue Tourmaline,Wedding Rings,Rings For Women.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('ad298c19-bd06-4a7e-99ee-37e254178eb1', '2.65 Cts Paraiba Colour Tourmaline', 'Presenting One Of The Best Colour In Tourmalines

Paraiba Colour Tourmaline 

Exceptional Colour Very Rare To Be Find, Bright Colour Not Dull.

More Beautiful In Real.

2.65 Cts 
8.8x6.7x4.8mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 491, 1, 'loose_stone', 'Tourmaline', 'Paraiba', 2.65, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/ad298c19-bd06-4a7e-99ee-37e254178eb1/etsy-1.jpg","https://media.gemworkers.com/items/ad298c19-bd06-4a7e-99ee-37e254178eb1/etsy-2.jpg","https://media.gemworkers.com/items/ad298c19-bd06-4a7e-99ee-37e254178eb1/etsy-3.jpg","https://media.gemworkers.com/items/ad298c19-bd06-4a7e-99ee-37e254178eb1/etsy-4.jpg","https://media.gemworkers.com/items/ad298c19-bd06-4a7e-99ee-37e254178eb1/etsy-5.jpg","https://media.gemworkers.com/items/ad298c19-bd06-4a7e-99ee-37e254178eb1/etsy-6.jpg","https://media.gemworkers.com/items/ad298c19-bd06-4a7e-99ee-37e254178eb1/etsy-7.jpg","https://media.gemworkers.com/items/ad298c19-bd06-4a7e-99ee-37e254178eb1/etsy-8.jpg","https://media.gemworkers.com/items/ad298c19-bd06-4a7e-99ee-37e254178eb1/etsy-9.jpg","https://media.gemworkers.com/items/ad298c19-bd06-4a7e-99ee-37e254178eb1/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 550 USD, converted at ECB rate. Etsy tags: Paraiba Tourmaline,Paraiba Colour,Lagoon Tourmaline,Bluegreen Tourmaline,Blue Tourmaline,Neon Blue Tourmaline,Tourmaline Jewellery,Jewellers,Lagoon Colour,Oceangemsminerals,Ink Blue Tourmaline,Wedding Rings,Rings For Women.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('2b061982-4603-4f06-b8c1-f4a9ccdecfeb', '2.4 Cts Lagoon Tourmaline', 'Presenting One Of The Best Colour In Tourmalines

Exceptional Colour Very Rare To Be Find, Bright Colour Not Dull.

More Beautiful In Real.

2.40 Cts 
8.2x6.2x5.4mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 267, 1, 'loose_stone', 'Tourmaline', NULL, 2.4, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/2b061982-4603-4f06-b8c1-f4a9ccdecfeb/etsy-1.jpg","https://media.gemworkers.com/items/2b061982-4603-4f06-b8c1-f4a9ccdecfeb/etsy-2.jpg","https://media.gemworkers.com/items/2b061982-4603-4f06-b8c1-f4a9ccdecfeb/etsy-3.jpg","https://media.gemworkers.com/items/2b061982-4603-4f06-b8c1-f4a9ccdecfeb/etsy-4.jpg","https://media.gemworkers.com/items/2b061982-4603-4f06-b8c1-f4a9ccdecfeb/etsy-5.jpg","https://media.gemworkers.com/items/2b061982-4603-4f06-b8c1-f4a9ccdecfeb/etsy-6.jpg","https://media.gemworkers.com/items/2b061982-4603-4f06-b8c1-f4a9ccdecfeb/etsy-7.jpg","https://media.gemworkers.com/items/2b061982-4603-4f06-b8c1-f4a9ccdecfeb/etsy-8.jpg","https://media.gemworkers.com/items/2b061982-4603-4f06-b8c1-f4a9ccdecfeb/etsy-9.jpg","https://media.gemworkers.com/items/2b061982-4603-4f06-b8c1-f4a9ccdecfeb/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 299 USD, converted at ECB rate. Etsy tags: Paraiba Tourmaline,Paraiba Colour,Lagoon Tourmaline,Bluegreen Tourmaline,Blue Tourmaline,Neon Blue Tourmaline,Tourmaline Jewellery,Jewellers,Lagoon Colour,Oceangemsminerals,Ink Blue Tourmaline,Wedding Rings,Rings For Women.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('38dca743-1d90-41f6-ba84-ac33e8f7becf', '2.10 Cts Lagoon Tourmaline', 'Presenting One Of The Best Colour In Tourmalines

Exceptional Colour Very Rare To Be Find, Bright Colour Not Dull.

More Beautiful In Real.

2.10 Cts 
7.1x6.3x5.3mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 356, 1, 'loose_stone', 'Tourmaline', NULL, 2.1, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/38dca743-1d90-41f6-ba84-ac33e8f7becf/etsy-1.jpg","https://media.gemworkers.com/items/38dca743-1d90-41f6-ba84-ac33e8f7becf/etsy-2.jpg","https://media.gemworkers.com/items/38dca743-1d90-41f6-ba84-ac33e8f7becf/etsy-3.jpg","https://media.gemworkers.com/items/38dca743-1d90-41f6-ba84-ac33e8f7becf/etsy-4.jpg","https://media.gemworkers.com/items/38dca743-1d90-41f6-ba84-ac33e8f7becf/etsy-5.jpg","https://media.gemworkers.com/items/38dca743-1d90-41f6-ba84-ac33e8f7becf/etsy-6.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 399 USD, converted at ECB rate. Etsy tags: Paraiba Tourmaline,Paraiba Colour,Lagoon Tourmaline,Bluegreen Tourmaline,Blue Tourmaline,Neon Blue Tourmaline,Tourmaline Jewellery,Jewellers,Lagoon Colour,Oceangemsminerals,Ink Blue Tourmaline,Wedding Rings,Rings For Women.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('09c370b8-1acf-471b-8312-46d0a82cb868', '2.6 Cts Pink Tourmaline Gemstones: Unheated, Untreated', 'Gorgeous Pink Tourmaline Set

For 3 Stone Ring 💍 

2.60 Cts
7.4 x 4.6 x 3.8mm
7.8 x 3.4 x 2.8mm

Unheated, Untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 447, 1, 'loose_stone', 'Tourmaline', NULL, 2.6, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/09c370b8-1acf-471b-8312-46d0a82cb868/etsy-1.jpg","https://media.gemworkers.com/items/09c370b8-1acf-471b-8312-46d0a82cb868/etsy-2.jpg","https://media.gemworkers.com/items/09c370b8-1acf-471b-8312-46d0a82cb868/etsy-3.jpg","https://media.gemworkers.com/items/09c370b8-1acf-471b-8312-46d0a82cb868/etsy-4.jpg","https://media.gemworkers.com/items/09c370b8-1acf-471b-8312-46d0a82cb868/etsy-5.jpg","https://media.gemworkers.com/items/09c370b8-1acf-471b-8312-46d0a82cb868/etsy-6.jpg","https://media.gemworkers.com/items/09c370b8-1acf-471b-8312-46d0a82cb868/etsy-7.jpg","https://media.gemworkers.com/items/09c370b8-1acf-471b-8312-46d0a82cb868/etsy-8.jpg","https://media.gemworkers.com/items/09c370b8-1acf-471b-8312-46d0a82cb868/etsy-9.jpg","https://media.gemworkers.com/items/09c370b8-1acf-471b-8312-46d0a82cb868/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 500 USD, converted at ECB rate. Etsy tags: y2k earrings stud,Natural Stone,Tourmaline Earrings,Tourmaline Jewellery,Earrings Findings,Tourmaline Jewels,Tourmaline Supplies,Rings For Women,pink tourmaline,lagoon tourmaline,Blue tourmaline,tourmaline pairs.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('557745dc-2026-43d1-a8c5-66ec71d018fc', '10.55 Cts, pink tourmaline lot', 'Elegant Afghan pink colour tourmaline 

High lustre, glowing and bright colour 

Excellent Cut

10.55 Cts
7.5 to 5.8mm

Unheated, Untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 893, 1, 'loose_stone', 'Tourmaline', NULL, 10.55, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/557745dc-2026-43d1-a8c5-66ec71d018fc/etsy-1.jpg","https://media.gemworkers.com/items/557745dc-2026-43d1-a8c5-66ec71d018fc/etsy-2.jpg","https://media.gemworkers.com/items/557745dc-2026-43d1-a8c5-66ec71d018fc/etsy-3.jpg","https://media.gemworkers.com/items/557745dc-2026-43d1-a8c5-66ec71d018fc/etsy-4.jpg","https://media.gemworkers.com/items/557745dc-2026-43d1-a8c5-66ec71d018fc/etsy-5.jpg","https://media.gemworkers.com/items/557745dc-2026-43d1-a8c5-66ec71d018fc/etsy-6.jpg","https://media.gemworkers.com/items/557745dc-2026-43d1-a8c5-66ec71d018fc/etsy-7.jpg","https://media.gemworkers.com/items/557745dc-2026-43d1-a8c5-66ec71d018fc/etsy-8.jpg","https://media.gemworkers.com/items/557745dc-2026-43d1-a8c5-66ec71d018fc/etsy-9.jpg","https://media.gemworkers.com/items/557745dc-2026-43d1-a8c5-66ec71d018fc/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 1000 USD, converted at ECB rate. Etsy tags: Jewellery Supplies,Jewellery Making,Rings For Men,Rings For Women,y2k earrings stud,Gift For Her,Tourmaline Jewellery,Natural Stone,Tourmaline Supplies,Jewellery Stud,pink tourmaline,Oceangemsminerals,orange tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('58f8c104-2788-4632-a433-41341f250495', '1 Cts Rubilite Tourmaline', 'Gorgeous Rubilite Tourmaline best for ring 💍 

Just Like Mehengi Spinel

1 Cts
8 x 4.4 x 3.3mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 179, 1, 'loose_stone', 'Tourmaline', 'Rubellite', 1, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/58f8c104-2788-4632-a433-41341f250495/etsy-1.jpg","https://media.gemworkers.com/items/58f8c104-2788-4632-a433-41341f250495/etsy-2.jpg","https://media.gemworkers.com/items/58f8c104-2788-4632-a433-41341f250495/etsy-3.jpg","https://media.gemworkers.com/items/58f8c104-2788-4632-a433-41341f250495/etsy-4.jpg","https://media.gemworkers.com/items/58f8c104-2788-4632-a433-41341f250495/etsy-5.jpg","https://media.gemworkers.com/items/58f8c104-2788-4632-a433-41341f250495/etsy-6.jpg","https://media.gemworkers.com/items/58f8c104-2788-4632-a433-41341f250495/etsy-7.jpg","https://media.gemworkers.com/items/58f8c104-2788-4632-a433-41341f250495/etsy-8.jpg","https://media.gemworkers.com/items/58f8c104-2788-4632-a433-41341f250495/etsy-9.jpg","https://media.gemworkers.com/items/58f8c104-2788-4632-a433-41341f250495/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 200 USD, converted at ECB rate. Etsy tags: Red Rubilite,PigeonBlood Rubilite,Orange Rubilite,Pinkish Rubilite,Red Tourmaline,Pink Tourmaline,Orange Tourmaline,Cushion Cut,Tourmaline Jewellery,Tourmaline Faceted,Rubilite Tourmaline,Jewellery Making,Jewellery Findings.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('a9bdf3bd-2b2b-481b-9dba-c92cfb91424d', '7 Cts Pink Tourmaline Gemstones: Unheated, Untreated', 'Gorgeous Pink Tourmalines

For Necklace 

7.00 Cts
11.8 x 8.4 x 5.1mm
10.1 x 10.1 x 4.4mm

Unheated, Untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 447, 1, 'loose_stone', 'Tourmaline', NULL, 7, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/a9bdf3bd-2b2b-481b-9dba-c92cfb91424d/etsy-1.jpg","https://media.gemworkers.com/items/a9bdf3bd-2b2b-481b-9dba-c92cfb91424d/etsy-2.jpg","https://media.gemworkers.com/items/a9bdf3bd-2b2b-481b-9dba-c92cfb91424d/etsy-3.jpg","https://media.gemworkers.com/items/a9bdf3bd-2b2b-481b-9dba-c92cfb91424d/etsy-4.jpg","https://media.gemworkers.com/items/a9bdf3bd-2b2b-481b-9dba-c92cfb91424d/etsy-5.jpg","https://media.gemworkers.com/items/a9bdf3bd-2b2b-481b-9dba-c92cfb91424d/etsy-6.jpg","https://media.gemworkers.com/items/a9bdf3bd-2b2b-481b-9dba-c92cfb91424d/etsy-7.jpg","https://media.gemworkers.com/items/a9bdf3bd-2b2b-481b-9dba-c92cfb91424d/etsy-8.jpg","https://media.gemworkers.com/items/a9bdf3bd-2b2b-481b-9dba-c92cfb91424d/etsy-9.jpg","https://media.gemworkers.com/items/a9bdf3bd-2b2b-481b-9dba-c92cfb91424d/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 500 USD, converted at ECB rate. Etsy tags: y2k earrings stud,Natural Stone,Tourmaline Earrings,Tourmaline Jewellery,Earrings Findings,Tourmaline Jewels,Tourmaline Supplies,Rings For Women,pink tourmaline,lagoon tourmaline,Blue tourmaline,tourmaline pairs.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('5d768348-70f8-4162-ba6b-efdc4cf3c3c7', '3.2 Cts Peach Pink Tourmaline', 'Peach Pink Tourmaline

gorgeous colour 

3.20 Cts
8.5 x 7.6 x 6.2mm

unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 268, 1, 'loose_stone', 'Tourmaline', NULL, 3.2, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/5d768348-70f8-4162-ba6b-efdc4cf3c3c7/etsy-1.jpg","https://media.gemworkers.com/items/5d768348-70f8-4162-ba6b-efdc4cf3c3c7/etsy-2.jpg","https://media.gemworkers.com/items/5d768348-70f8-4162-ba6b-efdc4cf3c3c7/etsy-3.jpg","https://media.gemworkers.com/items/5d768348-70f8-4162-ba6b-efdc4cf3c3c7/etsy-4.jpg","https://media.gemworkers.com/items/5d768348-70f8-4162-ba6b-efdc4cf3c3c7/etsy-5.jpg","https://media.gemworkers.com/items/5d768348-70f8-4162-ba6b-efdc4cf3c3c7/etsy-6.jpg","https://media.gemworkers.com/items/5d768348-70f8-4162-ba6b-efdc4cf3c3c7/etsy-7.jpg","https://media.gemworkers.com/items/5d768348-70f8-4162-ba6b-efdc4cf3c3c7/etsy-8.jpg","https://media.gemworkers.com/items/5d768348-70f8-4162-ba6b-efdc4cf3c3c7/etsy-9.jpg","https://media.gemworkers.com/items/5d768348-70f8-4162-ba6b-efdc4cf3c3c7/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 300 USD, converted at ECB rate. Etsy tags: rings for women,loose gemstones,natural stone,gold rings,gift for her,jewellery making,jewellery supplies,jewels,Handmadejewellery,jewellery findings,Pink Bicolour,pink tourmaline,bicolour tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('d33a2b5e-5f66-4eef-aba1-6bdc226f736f', '2.6 Cts Peach Pink Tourmaline', 'Mesmerising Peach Pink Colour Tourmaline 

Cut to perfection, Lustre And Brilliance 

2.6 Cts
8.4 x 6.8 x 5.5mm

Unheated,Untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 178, 1, 'loose_stone', 'Tourmaline', NULL, 2.6, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/d33a2b5e-5f66-4eef-aba1-6bdc226f736f/etsy-1.jpg","https://media.gemworkers.com/items/d33a2b5e-5f66-4eef-aba1-6bdc226f736f/etsy-2.jpg","https://media.gemworkers.com/items/d33a2b5e-5f66-4eef-aba1-6bdc226f736f/etsy-3.jpg","https://media.gemworkers.com/items/d33a2b5e-5f66-4eef-aba1-6bdc226f736f/etsy-4.jpg","https://media.gemworkers.com/items/d33a2b5e-5f66-4eef-aba1-6bdc226f736f/etsy-5.jpg","https://media.gemworkers.com/items/d33a2b5e-5f66-4eef-aba1-6bdc226f736f/etsy-6.jpg","https://media.gemworkers.com/items/d33a2b5e-5f66-4eef-aba1-6bdc226f736f/etsy-7.jpg","https://media.gemworkers.com/items/d33a2b5e-5f66-4eef-aba1-6bdc226f736f/etsy-8.jpg","https://media.gemworkers.com/items/d33a2b5e-5f66-4eef-aba1-6bdc226f736f/etsy-9.jpg","https://media.gemworkers.com/items/d33a2b5e-5f66-4eef-aba1-6bdc226f736f/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 199 USD, converted at ECB rate. Etsy tags: Gold Rings,Tourmaline Rings,Tourmaline Jewellery,Stud Rings,Rings For Women,Rings For Men,Jewellery Making,jewellery supplies,jewellery findings,y2k rings stud,loose gemstone,jewels,cushion.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('be3bbe1f-cf60-466c-98da-5159ed525b28', '2.25 Cts Bicolour Watermelon Tourmaline', 'Natural bicolour Watermelon mesmerising tourmaline 

2.25 Cts
8.4 x 5.6 x 4.4mm

unheated,', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 134, 1, 'loose_stone', 'Tourmaline', 'Watermelon', 2.25, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/be3bbe1f-cf60-466c-98da-5159ed525b28/etsy-1.jpg","https://media.gemworkers.com/items/be3bbe1f-cf60-466c-98da-5159ed525b28/etsy-2.jpg","https://media.gemworkers.com/items/be3bbe1f-cf60-466c-98da-5159ed525b28/etsy-3.jpg","https://media.gemworkers.com/items/be3bbe1f-cf60-466c-98da-5159ed525b28/etsy-4.jpg","https://media.gemworkers.com/items/be3bbe1f-cf60-466c-98da-5159ed525b28/etsy-5.jpg","https://media.gemworkers.com/items/be3bbe1f-cf60-466c-98da-5159ed525b28/etsy-6.jpg","https://media.gemworkers.com/items/be3bbe1f-cf60-466c-98da-5159ed525b28/etsy-7.jpg","https://media.gemworkers.com/items/be3bbe1f-cf60-466c-98da-5159ed525b28/etsy-8.jpg","https://media.gemworkers.com/items/be3bbe1f-cf60-466c-98da-5159ed525b28/etsy-9.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 150 USD, converted at ECB rate. Etsy tags: Rings for women,rings for men,natural stone,gift for her,jewellery making,jewellery supplies,jewellery findings,bicolour tourmaline,pink tourmaline,stud jewellery,tourmaline emerald,emerald cut,green tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('ca25a5bd-ec0f-4005-93f0-ad6d06d9ae9a', '5.65 Cts Peach Pink Tourmaline', 'Peach Pink Tourmaline With Golden colour 

gorgeous colour 

5.65 Cts
10.9 x 8.6 x 7.4mm

unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 268, 1, 'loose_stone', 'Tourmaline', NULL, 5.65, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/ca25a5bd-ec0f-4005-93f0-ad6d06d9ae9a/etsy-1.jpg","https://media.gemworkers.com/items/ca25a5bd-ec0f-4005-93f0-ad6d06d9ae9a/etsy-2.jpg","https://media.gemworkers.com/items/ca25a5bd-ec0f-4005-93f0-ad6d06d9ae9a/etsy-3.jpg","https://media.gemworkers.com/items/ca25a5bd-ec0f-4005-93f0-ad6d06d9ae9a/etsy-4.jpg","https://media.gemworkers.com/items/ca25a5bd-ec0f-4005-93f0-ad6d06d9ae9a/etsy-5.jpg","https://media.gemworkers.com/items/ca25a5bd-ec0f-4005-93f0-ad6d06d9ae9a/etsy-6.jpg","https://media.gemworkers.com/items/ca25a5bd-ec0f-4005-93f0-ad6d06d9ae9a/etsy-7.jpg","https://media.gemworkers.com/items/ca25a5bd-ec0f-4005-93f0-ad6d06d9ae9a/etsy-8.jpg","https://media.gemworkers.com/items/ca25a5bd-ec0f-4005-93f0-ad6d06d9ae9a/etsy-9.jpg","https://media.gemworkers.com/items/ca25a5bd-ec0f-4005-93f0-ad6d06d9ae9a/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 300 USD, converted at ECB rate. Etsy tags: rings for women,loose gemstones,natural stone,gold rings,gift for her,jewellery making,jewellery supplies,jewels,Handmadejewellery,jewellery findings,Pink Bicolour,pink tourmaline,bicolour tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('976ea2de-1f76-46a3-a8ea-da5952cabc99', 'Tricolour Tourmaline pairs', 'unique combinations tourmaline pairs

Very Bright And Glowing Polish  

Good size and lustre

Unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 268, 1, 'loose_stone', 'Tourmaline', NULL, NULL, NULL, NULL, NULL, NULL, '["https://media.gemworkers.com/items/976ea2de-1f76-46a3-a8ea-da5952cabc99/etsy-1.jpg","https://media.gemworkers.com/items/976ea2de-1f76-46a3-a8ea-da5952cabc99/etsy-2.jpg","https://media.gemworkers.com/items/976ea2de-1f76-46a3-a8ea-da5952cabc99/etsy-3.jpg","https://media.gemworkers.com/items/976ea2de-1f76-46a3-a8ea-da5952cabc99/etsy-4.jpg","https://media.gemworkers.com/items/976ea2de-1f76-46a3-a8ea-da5952cabc99/etsy-5.jpg","https://media.gemworkers.com/items/976ea2de-1f76-46a3-a8ea-da5952cabc99/etsy-6.jpg","https://media.gemworkers.com/items/976ea2de-1f76-46a3-a8ea-da5952cabc99/etsy-7.jpg","https://media.gemworkers.com/items/976ea2de-1f76-46a3-a8ea-da5952cabc99/etsy-8.jpg","https://media.gemworkers.com/items/976ea2de-1f76-46a3-a8ea-da5952cabc99/etsy-9.jpg","https://media.gemworkers.com/items/976ea2de-1f76-46a3-a8ea-da5952cabc99/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 300 USD, converted at ECB rate. Etsy tags: Tricolour Tourmaline,Tourmaline Pairs,Tricolour Pairs,Unique Tourmaline,Unique Pairs,Blue Tricolour Pairs,Blue tourmaline pair,Lagoon Tourmaline,Neon Tourmaline,Rare Tourmaline,Rare Tricolour Pairs,Oceangemsminerals,Ink blue Tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('0a9a2870-0fd5-4592-b831-b96078cc2b4c', '9.35 Cts Chrome green & Bicolour Tourmalines', 'Gorgeous Mesmerising Chrome Green & Bicolour Afghan Tourmalines

One Of A Kind

9.35 Cts
9.3 x 7.2 x 5.2mm 
8.9 x 7.3 x 5.2mm
7.3 x 6.4 x 4.8mm
10 x 4.5 x 3.5mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 268, 1, 'loose_stone', 'Tourmaline', NULL, 9.35, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/0a9a2870-0fd5-4592-b831-b96078cc2b4c/etsy-1.jpg","https://media.gemworkers.com/items/0a9a2870-0fd5-4592-b831-b96078cc2b4c/etsy-2.jpg","https://media.gemworkers.com/items/0a9a2870-0fd5-4592-b831-b96078cc2b4c/etsy-3.jpg","https://media.gemworkers.com/items/0a9a2870-0fd5-4592-b831-b96078cc2b4c/etsy-4.jpg","https://media.gemworkers.com/items/0a9a2870-0fd5-4592-b831-b96078cc2b4c/etsy-5.jpg","https://media.gemworkers.com/items/0a9a2870-0fd5-4592-b831-b96078cc2b4c/etsy-6.jpg","https://media.gemworkers.com/items/0a9a2870-0fd5-4592-b831-b96078cc2b4c/etsy-7.jpg","https://media.gemworkers.com/items/0a9a2870-0fd5-4592-b831-b96078cc2b4c/etsy-8.jpg","https://media.gemworkers.com/items/0a9a2870-0fd5-4592-b831-b96078cc2b4c/etsy-9.jpg","https://media.gemworkers.com/items/0a9a2870-0fd5-4592-b831-b96078cc2b4c/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 300 USD, converted at ECB rate. Etsy tags: Tourmaline Jewellery,Jewellery Supplies,Jewellery Making,Jewellery Findings,Tourmaline Earrings,Earrings Stud,y2k earrings stud,Gold Rings,Natural Stone,Gift For Her,Rings For Men,Rings For Women,Chrome Tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('c5928dd2-a891-42ee-8cba-a836210b80e6', '1.7 Cts Neon Blue Tourmaline', 'lagoon and neon blue colour tourmaline Lot

top colour high lustre and brilliance 

Paraiba Like Colour

1.70  Cts 
6.5x5.8x5.1mm

100% natural no treatment whatsoever.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 357, 1, 'loose_stone', 'Tourmaline', NULL, 1.7, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/c5928dd2-a891-42ee-8cba-a836210b80e6/etsy-1.jpg","https://media.gemworkers.com/items/c5928dd2-a891-42ee-8cba-a836210b80e6/etsy-2.jpg","https://media.gemworkers.com/items/c5928dd2-a891-42ee-8cba-a836210b80e6/etsy-3.jpg","https://media.gemworkers.com/items/c5928dd2-a891-42ee-8cba-a836210b80e6/etsy-4.jpg","https://media.gemworkers.com/items/c5928dd2-a891-42ee-8cba-a836210b80e6/etsy-5.jpg","https://media.gemworkers.com/items/c5928dd2-a891-42ee-8cba-a836210b80e6/etsy-6.jpg","https://media.gemworkers.com/items/c5928dd2-a891-42ee-8cba-a836210b80e6/etsy-7.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 400 USD, converted at ECB rate. Etsy tags: Natural Stone,Jewellery Supplies,Jewellery Making,Jewellery Findings,y2k stud earrings,Gift For Her,Rings For Men,Rings For Women,Gold Rings,Silver Sterling,Garnet Necklace,Garnet Rings,Garnet Jewellery.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('571d1237-5e4b-42d6-b9d5-72653b3bfd4f', '7.75 Cts Pink Tourmalines', 'Gorgeous Pink Tourmaline 

Cut Looking And Very Best Price

7.75 Cts
9.1 x 7.2 x 6.3mm
7.5 x 6 x 4.8mm
7.7 x 6.8 x umm     

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 197, 1, 'loose_stone', 'Tourmaline', NULL, 7.75, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/571d1237-5e4b-42d6-b9d5-72653b3bfd4f/etsy-1.jpg","https://media.gemworkers.com/items/571d1237-5e4b-42d6-b9d5-72653b3bfd4f/etsy-2.jpg","https://media.gemworkers.com/items/571d1237-5e4b-42d6-b9d5-72653b3bfd4f/etsy-3.jpg","https://media.gemworkers.com/items/571d1237-5e4b-42d6-b9d5-72653b3bfd4f/etsy-4.jpg","https://media.gemworkers.com/items/571d1237-5e4b-42d6-b9d5-72653b3bfd4f/etsy-5.jpg","https://media.gemworkers.com/items/571d1237-5e4b-42d6-b9d5-72653b3bfd4f/etsy-6.jpg","https://media.gemworkers.com/items/571d1237-5e4b-42d6-b9d5-72653b3bfd4f/etsy-7.jpg","https://media.gemworkers.com/items/571d1237-5e4b-42d6-b9d5-72653b3bfd4f/etsy-8.jpg","https://media.gemworkers.com/items/571d1237-5e4b-42d6-b9d5-72653b3bfd4f/etsy-9.jpg","https://media.gemworkers.com/items/571d1237-5e4b-42d6-b9d5-72653b3bfd4f/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 220 USD, converted at ECB rate. Etsy tags: Red Tourmaline,Hot Pink Tourmaline,Pink Tourmaline,Orange Tourmaline,Unique Tourmaline,Tourmaline Jewellery,Faceted Tourmaline,Step Cushion Cut,Feceted Tourmaline,Afghan Tourmaline,Oceangemsminerals,Purple Tourmaline,Lavender Tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('5f72665e-cc80-4214-b0f7-adb8097dfc9b', '5.75 Cts Lagoon Blue tourmaline', 'Lagoon Blue Tourmaline 

5.75 Cts 
13.2x7.2x6.1mm

no treatment.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 625, 1, 'loose_stone', 'Tourmaline', NULL, 5.75, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/5f72665e-cc80-4214-b0f7-adb8097dfc9b/etsy-1.jpg","https://media.gemworkers.com/items/5f72665e-cc80-4214-b0f7-adb8097dfc9b/etsy-2.jpg","https://media.gemworkers.com/items/5f72665e-cc80-4214-b0f7-adb8097dfc9b/etsy-3.jpg","https://media.gemworkers.com/items/5f72665e-cc80-4214-b0f7-adb8097dfc9b/etsy-4.jpg","https://media.gemworkers.com/items/5f72665e-cc80-4214-b0f7-adb8097dfc9b/etsy-5.jpg","https://media.gemworkers.com/items/5f72665e-cc80-4214-b0f7-adb8097dfc9b/etsy-6.jpg","https://media.gemworkers.com/items/5f72665e-cc80-4214-b0f7-adb8097dfc9b/etsy-7.jpg","https://media.gemworkers.com/items/5f72665e-cc80-4214-b0f7-adb8097dfc9b/etsy-8.jpg","https://media.gemworkers.com/items/5f72665e-cc80-4214-b0f7-adb8097dfc9b/etsy-9.jpg","https://media.gemworkers.com/items/5f72665e-cc80-4214-b0f7-adb8097dfc9b/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 700 USD, converted at ECB rate. Etsy tags: Blue Bicolour,Bicolour Tourmaline,Blue Tourmaline,Lavender Tourmaline,Purple Tourmaline,Lagoon tourmaline,neon blue tourmaline,jewellery making,jewellery findings,jewellery supplies,gift for her,Natural stone,Handmadejewellery.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('fccdd2b5-19d7-4f0c-8ef4-ad0a7a3f8ea0', '14.7 Cts Lagoon Tourmaline Lot', 'Gorgeous Mesmerising Lagoon Afghan Tourmaline Lot

Unique Colour 

14.70 Cts 

Average Sizes
7x6.7x5.6mm
8.1x8x6.9xmm
8.6x8x6.7mm


Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 1313, 1, 'loose_stone', 'Tourmaline', NULL, 14.7, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/fccdd2b5-19d7-4f0c-8ef4-ad0a7a3f8ea0/etsy-1.jpg","https://media.gemworkers.com/items/fccdd2b5-19d7-4f0c-8ef4-ad0a7a3f8ea0/etsy-2.jpg","https://media.gemworkers.com/items/fccdd2b5-19d7-4f0c-8ef4-ad0a7a3f8ea0/etsy-3.jpg","https://media.gemworkers.com/items/fccdd2b5-19d7-4f0c-8ef4-ad0a7a3f8ea0/etsy-4.jpg","https://media.gemworkers.com/items/fccdd2b5-19d7-4f0c-8ef4-ad0a7a3f8ea0/etsy-5.jpg","https://media.gemworkers.com/items/fccdd2b5-19d7-4f0c-8ef4-ad0a7a3f8ea0/etsy-6.jpg","https://media.gemworkers.com/items/fccdd2b5-19d7-4f0c-8ef4-ad0a7a3f8ea0/etsy-7.jpg","https://media.gemworkers.com/items/fccdd2b5-19d7-4f0c-8ef4-ad0a7a3f8ea0/etsy-8.jpg","https://media.gemworkers.com/items/fccdd2b5-19d7-4f0c-8ef4-ad0a7a3f8ea0/etsy-9.jpg","https://media.gemworkers.com/items/fccdd2b5-19d7-4f0c-8ef4-ad0a7a3f8ea0/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 1470 USD, converted at ECB rate. Etsy tags: BlueGreen Tourmaline,Blue Tourmaline,Green Tourmaline,Lagoon Tourmaline,Neon Tourmaline,Tourmaline Rings,rings for women,rings for men,jewellery making,jewellery supplies,jewellery findings,gift for her,natural stone.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('1fb5aa10-0bc5-4c82-88ef-4ed1f4bf326c', '4 Cts Tourmaline Earrings Set', 'Gorgeous Tourmaline Set For Earrings 

Excellent Cut And Quality 

Ethically Sourced 

4 Cts
6.6 x 3.5 x 2.9mm
5.2 x 4.6 x 3.9mm
6.1 x 3.6 x 3.1mm

Unheated, Untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 402, 1, 'jewelry', 'Tourmaline', NULL, 4, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/1fb5aa10-0bc5-4c82-88ef-4ed1f4bf326c/etsy-1.jpg","https://media.gemworkers.com/items/1fb5aa10-0bc5-4c82-88ef-4ed1f4bf326c/etsy-2.jpg","https://media.gemworkers.com/items/1fb5aa10-0bc5-4c82-88ef-4ed1f4bf326c/etsy-3.jpg","https://media.gemworkers.com/items/1fb5aa10-0bc5-4c82-88ef-4ed1f4bf326c/etsy-4.jpg","https://media.gemworkers.com/items/1fb5aa10-0bc5-4c82-88ef-4ed1f4bf326c/etsy-5.jpg","https://media.gemworkers.com/items/1fb5aa10-0bc5-4c82-88ef-4ed1f4bf326c/etsy-6.jpg","https://media.gemworkers.com/items/1fb5aa10-0bc5-4c82-88ef-4ed1f4bf326c/etsy-7.jpg","https://media.gemworkers.com/items/1fb5aa10-0bc5-4c82-88ef-4ed1f4bf326c/etsy-8.jpg","https://media.gemworkers.com/items/1fb5aa10-0bc5-4c82-88ef-4ed1f4bf326c/etsy-9.jpg","https://media.gemworkers.com/items/1fb5aa10-0bc5-4c82-88ef-4ed1f4bf326c/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 450 USD, converted at ECB rate. Etsy tags: Spinel Jewellery,Spinel Rings,Unique Spinel,Jewellery Making,Jewellery Supplies,Oceangemsminerals,Spinel Necklace,Natural Stone,Tourmaline Set,Pink Tourmaline,Lagoon Tourmaline,Blue Tourmaline,Seafoam Tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('0bc9fd68-c5be-4616-8289-7a09d2e5e76f', '3.75 Cts Tourmaline Earrings Set', 'Gorgeous Tourmaline Set For Earrings 

Excellent Cut And Quality 

Ethically Sourced 

3.75 Cts
4.1 x 4.1 x 3.1mm
5.8 x 5. X 4.2mm
4.8 x 3.2 x 2.8mm

Unheated, Untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 402, 1, 'jewelry', 'Tourmaline', NULL, 3.75, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/0bc9fd68-c5be-4616-8289-7a09d2e5e76f/etsy-1.jpg","https://media.gemworkers.com/items/0bc9fd68-c5be-4616-8289-7a09d2e5e76f/etsy-2.jpg","https://media.gemworkers.com/items/0bc9fd68-c5be-4616-8289-7a09d2e5e76f/etsy-3.jpg","https://media.gemworkers.com/items/0bc9fd68-c5be-4616-8289-7a09d2e5e76f/etsy-4.jpg","https://media.gemworkers.com/items/0bc9fd68-c5be-4616-8289-7a09d2e5e76f/etsy-5.jpg","https://media.gemworkers.com/items/0bc9fd68-c5be-4616-8289-7a09d2e5e76f/etsy-6.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 450 USD, converted at ECB rate. Etsy tags: Spinel Jewellery,Spinel Rings,Pink Spinel,Unique Spinel,Jewellery Making,Jewellery Supplies,Oceangemsminerals,Spinel Necklace,Natural Stone,Tourmaline Set,Pink Tourmaline,Lagoon Tourmaline,Blue Tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('a5398f55-51c7-4d12-bb03-ea183a90b3cd', '2.45 Cts Tourmaline Earrings Set', 'A Very High Lustre Unique Colour Tourmaline Set For Earrings 

High Quality Fine Cut

2.45 Cts
6.6 x 3.6 x 3.2mm
4.8 x 3.6 x 2.9mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 219, 1, 'jewelry', 'Tourmaline', NULL, 2.45, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/a5398f55-51c7-4d12-bb03-ea183a90b3cd/etsy-1.jpg","https://media.gemworkers.com/items/a5398f55-51c7-4d12-bb03-ea183a90b3cd/etsy-2.jpg","https://media.gemworkers.com/items/a5398f55-51c7-4d12-bb03-ea183a90b3cd/etsy-3.jpg","https://media.gemworkers.com/items/a5398f55-51c7-4d12-bb03-ea183a90b3cd/etsy-4.jpg","https://media.gemworkers.com/items/a5398f55-51c7-4d12-bb03-ea183a90b3cd/etsy-5.jpg","https://media.gemworkers.com/items/a5398f55-51c7-4d12-bb03-ea183a90b3cd/etsy-6.jpg","https://media.gemworkers.com/items/a5398f55-51c7-4d12-bb03-ea183a90b3cd/etsy-7.jpg","https://media.gemworkers.com/items/a5398f55-51c7-4d12-bb03-ea183a90b3cd/etsy-8.jpg","https://media.gemworkers.com/items/a5398f55-51c7-4d12-bb03-ea183a90b3cd/etsy-9.jpg","https://media.gemworkers.com/items/a5398f55-51c7-4d12-bb03-ea183a90b3cd/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 245 USD, converted at ECB rate. Etsy tags: Tourmaline Earrings,Earrings Set,Fine Tourmaline,Canary Tourmaline,Lagoon Tourmaline,Blue Tourmaline,Yellow Tourmaline,Stud Earrings,Tourmaline Jewellery,Jewellery Set,Oceangemsminerals,Tourmaline Pairs,Lagoon Pairs.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('a7d8ea11-6e56-4d6f-bc54-c5fdad6d8466', '10.55 Cts Rare Bicolour Tourmaline', 'To All The Bicolour Lovers Here Is An Incredible Opportunity Buy A Truly Exceptional And One Of A Kind Bicolour Tourmaline

Collection worthy 

10.55 Cts 
15.8x9.2x7.4mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 536, 1, 'loose_stone', 'Tourmaline', NULL, 10.55, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/a7d8ea11-6e56-4d6f-bc54-c5fdad6d8466/etsy-1.jpg","https://media.gemworkers.com/items/a7d8ea11-6e56-4d6f-bc54-c5fdad6d8466/etsy-2.jpg","https://media.gemworkers.com/items/a7d8ea11-6e56-4d6f-bc54-c5fdad6d8466/etsy-3.jpg","https://media.gemworkers.com/items/a7d8ea11-6e56-4d6f-bc54-c5fdad6d8466/etsy-4.jpg","https://media.gemworkers.com/items/a7d8ea11-6e56-4d6f-bc54-c5fdad6d8466/etsy-5.jpg","https://media.gemworkers.com/items/a7d8ea11-6e56-4d6f-bc54-c5fdad6d8466/etsy-6.jpg","https://media.gemworkers.com/items/a7d8ea11-6e56-4d6f-bc54-c5fdad6d8466/etsy-7.jpg","https://media.gemworkers.com/items/a7d8ea11-6e56-4d6f-bc54-c5fdad6d8466/etsy-8.jpg","https://media.gemworkers.com/items/a7d8ea11-6e56-4d6f-bc54-c5fdad6d8466/etsy-9.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 600 USD, converted at ECB rate. Etsy tags: pink tourmaline,rings for women,unique tourmaline,jewels,Handmadejewellery,gift for her,Topqualitytourmaline,Bicolour Tourmaline,Unique Bicolour,Rare Tourmaline,Oceangemsminerals,Tourmaline Pairs,Bicolour Pairs.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('936a1a67-d008-40ce-8613-e4b5a5fab9a9', '8 Cts Rare Tourmaline Lot', 'Gorgeous Best Colour And And Best Cut Tourmaline Lot

elegant and glowing, rare find

8 Cts
8.6 to 5.5mm

Unheated, Untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 268, 1, 'loose_stone', 'Tourmaline', NULL, 8, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/936a1a67-d008-40ce-8613-e4b5a5fab9a9/etsy-1.jpg","https://media.gemworkers.com/items/936a1a67-d008-40ce-8613-e4b5a5fab9a9/etsy-2.jpg","https://media.gemworkers.com/items/936a1a67-d008-40ce-8613-e4b5a5fab9a9/etsy-3.jpg","https://media.gemworkers.com/items/936a1a67-d008-40ce-8613-e4b5a5fab9a9/etsy-4.jpg","https://media.gemworkers.com/items/936a1a67-d008-40ce-8613-e4b5a5fab9a9/etsy-5.jpg","https://media.gemworkers.com/items/936a1a67-d008-40ce-8613-e4b5a5fab9a9/etsy-6.jpg","https://media.gemworkers.com/items/936a1a67-d008-40ce-8613-e4b5a5fab9a9/etsy-7.jpg","https://media.gemworkers.com/items/936a1a67-d008-40ce-8613-e4b5a5fab9a9/etsy-8.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 300 USD, converted at ECB rate. Etsy tags: Jewellery Making,Rings For Women,Jewellery Finding,Rings For Men,Gemstones Jewellery,Crystals,Gold Rings,Gold Ring,Jewellery Supplies,Gift For Her,Stud Earrings,Natural Stone,Bicolour Tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('55f4992c-d9c2-4ed4-9af1-b61c205f4a1a', '6.70 Cts Blue Green Tourmaline', 'Mesmerising Blue Green Colour Afghan Tourmaline 

Ethically sourced, 

best for ring

6.70 Cts
12.9 x 8.9 x 5.9mm

Unheated, Untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 250, 1, 'loose_stone', 'Tourmaline', NULL, 6.7, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/55f4992c-d9c2-4ed4-9af1-b61c205f4a1a/etsy-1.jpg","https://media.gemworkers.com/items/55f4992c-d9c2-4ed4-9af1-b61c205f4a1a/etsy-2.jpg","https://media.gemworkers.com/items/55f4992c-d9c2-4ed4-9af1-b61c205f4a1a/etsy-3.jpg","https://media.gemworkers.com/items/55f4992c-d9c2-4ed4-9af1-b61c205f4a1a/etsy-4.jpg","https://media.gemworkers.com/items/55f4992c-d9c2-4ed4-9af1-b61c205f4a1a/etsy-5.jpg","https://media.gemworkers.com/items/55f4992c-d9c2-4ed4-9af1-b61c205f4a1a/etsy-6.jpg","https://media.gemworkers.com/items/55f4992c-d9c2-4ed4-9af1-b61c205f4a1a/etsy-7.jpg","https://media.gemworkers.com/items/55f4992c-d9c2-4ed4-9af1-b61c205f4a1a/etsy-8.jpg","https://media.gemworkers.com/items/55f4992c-d9c2-4ed4-9af1-b61c205f4a1a/etsy-9.jpg","https://media.gemworkers.com/items/55f4992c-d9c2-4ed4-9af1-b61c205f4a1a/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 280 USD, converted at ECB rate. Etsy tags: Bluegreen Tourmaline,Blue Tourmaline,Green Tourmaline,Jewellery supplies,jewellery making,jewellery findings,jewels,Handmadejewellery,cushion cut,gift for her,natural stone,gold rings,silver stirring.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('0851ddc6-eca1-4d0a-98b8-0ea8ae1db494', '7.1 Cts Bright Bicolour Tourmalines', 'Sweet and bright Bicolour Tourmalines

Unique And Rare Colour

7.10 Cts
10.9 to 7.1mm

No treatment.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 313, 1, 'loose_stone', 'Tourmaline', NULL, 7.1, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/0851ddc6-eca1-4d0a-98b8-0ea8ae1db494/etsy-1.jpg","https://media.gemworkers.com/items/0851ddc6-eca1-4d0a-98b8-0ea8ae1db494/etsy-2.jpg","https://media.gemworkers.com/items/0851ddc6-eca1-4d0a-98b8-0ea8ae1db494/etsy-3.jpg","https://media.gemworkers.com/items/0851ddc6-eca1-4d0a-98b8-0ea8ae1db494/etsy-4.jpg","https://media.gemworkers.com/items/0851ddc6-eca1-4d0a-98b8-0ea8ae1db494/etsy-5.jpg","https://media.gemworkers.com/items/0851ddc6-eca1-4d0a-98b8-0ea8ae1db494/etsy-6.jpg","https://media.gemworkers.com/items/0851ddc6-eca1-4d0a-98b8-0ea8ae1db494/etsy-7.jpg","https://media.gemworkers.com/items/0851ddc6-eca1-4d0a-98b8-0ea8ae1db494/etsy-8.jpg","https://media.gemworkers.com/items/0851ddc6-eca1-4d0a-98b8-0ea8ae1db494/etsy-9.jpg","https://media.gemworkers.com/items/0851ddc6-eca1-4d0a-98b8-0ea8ae1db494/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 350 USD, converted at ECB rate. Etsy tags: Tourmaline Jewellery,Tourmaline Earrings,Earrings Stud,y2k earrings stud,Gold Rings,Natural Stone,Gift For Her,Rings For Men,Oceangemsminerals,lagoon tourmaline,tourmaline pairs,bicolour tourmaline,Watermelon Bicolour.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('b7516c14-a2e2-49c3-809a-d157fdbe1860', '2.10 Cts Lagoon Tourmaline', 'Presenting One Of The Best Colour In Tourmalines

Exceptional Colour Very Rare To Be Find, Bright Colour Not Dull.

More Beautiful In Real.

2.10 Cts
7.6 x 6.5 x 5.5mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 223, 1, 'loose_stone', 'Tourmaline', NULL, 2.1, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/b7516c14-a2e2-49c3-809a-d157fdbe1860/etsy-1.jpg","https://media.gemworkers.com/items/b7516c14-a2e2-49c3-809a-d157fdbe1860/etsy-2.jpg","https://media.gemworkers.com/items/b7516c14-a2e2-49c3-809a-d157fdbe1860/etsy-3.jpg","https://media.gemworkers.com/items/b7516c14-a2e2-49c3-809a-d157fdbe1860/etsy-4.jpg","https://media.gemworkers.com/items/b7516c14-a2e2-49c3-809a-d157fdbe1860/etsy-5.jpg","https://media.gemworkers.com/items/b7516c14-a2e2-49c3-809a-d157fdbe1860/etsy-6.jpg","https://media.gemworkers.com/items/b7516c14-a2e2-49c3-809a-d157fdbe1860/etsy-7.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 250 USD, converted at ECB rate. Etsy tags: Paraiba Tourmaline,Paraiba Colour,Lagoon Tourmaline,Bluegreen Tourmaline,Blue Tourmaline,Neon Blue Tourmaline,Tourmaline Jewellery,Jewellers,Lagoon Colour,Oceangemsminerals,Ink Blue Tourmaline,Wedding Rings,Rings For Women.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('4ec40aa5-756a-4d1b-9a6c-8bdec7e205c7', '8 Cts Lagoon Bicolour Tourmaline Pair', 'Gorgeous Mesmerising Lagoon Bicolour Natural Afghanistan Tourmaline Pair

More beautiful In real, One of a kind

95% Clean

8 Cts 
21.9x4.8x3.7mm

unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 893, 1, 'loose_stone', 'Tourmaline', NULL, 8, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/4ec40aa5-756a-4d1b-9a6c-8bdec7e205c7/etsy-1.jpg","https://media.gemworkers.com/items/4ec40aa5-756a-4d1b-9a6c-8bdec7e205c7/etsy-2.jpg","https://media.gemworkers.com/items/4ec40aa5-756a-4d1b-9a6c-8bdec7e205c7/etsy-3.jpg","https://media.gemworkers.com/items/4ec40aa5-756a-4d1b-9a6c-8bdec7e205c7/etsy-4.jpg","https://media.gemworkers.com/items/4ec40aa5-756a-4d1b-9a6c-8bdec7e205c7/etsy-5.jpg","https://media.gemworkers.com/items/4ec40aa5-756a-4d1b-9a6c-8bdec7e205c7/etsy-6.jpg","https://media.gemworkers.com/items/4ec40aa5-756a-4d1b-9a6c-8bdec7e205c7/etsy-7.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 1000 USD, converted at ECB rate. Etsy tags: Jewellery Supplies,Jewellery Making,Gold Rings,Rings For Men,Rings For Women,y2k earrings stud,Gift For Her,Tourmaline Jewellery,Natural Stone,Stud Earrings,Jewellery Stud,bicolour Tourmaline,Lagoon tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('fe7c5732-c5a6-4ab8-83de-c7fd72767a1a', '3 Cts Lagoon Bicolour Tourmaline Pair', 'Gorgeous Mesmerising Lagoon Bicolour Natural Afghanistan Tourmaline Pair

More beautiful In real, One of a kind

Loupe Clean

3 Cts 
13.4x3.8x2.8mm

unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 447, 1, 'loose_stone', 'Tourmaline', NULL, 3, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/fe7c5732-c5a6-4ab8-83de-c7fd72767a1a/etsy-1.jpg","https://media.gemworkers.com/items/fe7c5732-c5a6-4ab8-83de-c7fd72767a1a/etsy-2.jpg","https://media.gemworkers.com/items/fe7c5732-c5a6-4ab8-83de-c7fd72767a1a/etsy-3.jpg","https://media.gemworkers.com/items/fe7c5732-c5a6-4ab8-83de-c7fd72767a1a/etsy-4.jpg","https://media.gemworkers.com/items/fe7c5732-c5a6-4ab8-83de-c7fd72767a1a/etsy-5.jpg","https://media.gemworkers.com/items/fe7c5732-c5a6-4ab8-83de-c7fd72767a1a/etsy-6.jpg","https://media.gemworkers.com/items/fe7c5732-c5a6-4ab8-83de-c7fd72767a1a/etsy-7.jpg","https://media.gemworkers.com/items/fe7c5732-c5a6-4ab8-83de-c7fd72767a1a/etsy-8.jpg","https://media.gemworkers.com/items/fe7c5732-c5a6-4ab8-83de-c7fd72767a1a/etsy-9.jpg","https://media.gemworkers.com/items/fe7c5732-c5a6-4ab8-83de-c7fd72767a1a/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 500 USD, converted at ECB rate. Etsy tags: Jewellery Supplies,Jewellery Making,Gold Rings,Rings For Men,Rings For Women,y2k earrings stud,Gift For Her,Tourmaline Jewellery,Natural Stone,Stud Earrings,Jewellery Stud,bicolour Tourmaline,Lagoon tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('72fd473a-8d67-4661-9fe7-67a3da33e305', '2 Cts Lagoon Green Tourmaline Pair', 'Gorgeous Mesmerising Lagoon Green Colour Natural Afghanistan Tourmaline Pair

More beautiful In real, One of a kind

2 Cts 
7.6x4.3x3.2mm

unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 322, 1, 'loose_stone', 'Tourmaline', NULL, 2, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/72fd473a-8d67-4661-9fe7-67a3da33e305/etsy-1.jpg","https://media.gemworkers.com/items/72fd473a-8d67-4661-9fe7-67a3da33e305/etsy-2.jpg","https://media.gemworkers.com/items/72fd473a-8d67-4661-9fe7-67a3da33e305/etsy-3.jpg","https://media.gemworkers.com/items/72fd473a-8d67-4661-9fe7-67a3da33e305/etsy-4.jpg","https://media.gemworkers.com/items/72fd473a-8d67-4661-9fe7-67a3da33e305/etsy-5.jpg","https://media.gemworkers.com/items/72fd473a-8d67-4661-9fe7-67a3da33e305/etsy-6.jpg","https://media.gemworkers.com/items/72fd473a-8d67-4661-9fe7-67a3da33e305/etsy-7.jpg","https://media.gemworkers.com/items/72fd473a-8d67-4661-9fe7-67a3da33e305/etsy-8.jpg","https://media.gemworkers.com/items/72fd473a-8d67-4661-9fe7-67a3da33e305/etsy-9.jpg","https://media.gemworkers.com/items/72fd473a-8d67-4661-9fe7-67a3da33e305/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 360 USD, converted at ECB rate. Etsy tags: Jewellery Supplies,Jewellery Making,Gold Rings,Rings For Men,Rings For Women,y2k earrings stud,Gift For Her,Tourmaline Jewellery,Natural Stone,Stud Earrings,Jewellery Stud,bicolour Tourmaline,Lagoon tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('02ff934d-ee16-47d3-9b25-abccdb35dd2b', '13.10 Cts Bicolour Tourmaline', 'Gorgeous Bicolour Big Size Tourmaline 

13.10 Cts
17.4 x 10.7 x 7.7mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 174, 1, 'loose_stone', 'Tourmaline', NULL, 13.1, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/02ff934d-ee16-47d3-9b25-abccdb35dd2b/etsy-1.jpg","https://media.gemworkers.com/items/02ff934d-ee16-47d3-9b25-abccdb35dd2b/etsy-2.jpg","https://media.gemworkers.com/items/02ff934d-ee16-47d3-9b25-abccdb35dd2b/etsy-3.jpg","https://media.gemworkers.com/items/02ff934d-ee16-47d3-9b25-abccdb35dd2b/etsy-4.jpg","https://media.gemworkers.com/items/02ff934d-ee16-47d3-9b25-abccdb35dd2b/etsy-5.jpg","https://media.gemworkers.com/items/02ff934d-ee16-47d3-9b25-abccdb35dd2b/etsy-6.jpg","https://media.gemworkers.com/items/02ff934d-ee16-47d3-9b25-abccdb35dd2b/etsy-7.jpg","https://media.gemworkers.com/items/02ff934d-ee16-47d3-9b25-abccdb35dd2b/etsy-8.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 195 USD, converted at ECB rate. Etsy tags: Emerald Cut,Bicolour Tourmaline,Tricolour Tourmaline,Pink Bicolour,Tourmaline jewellery,Natural Stone,Blue tourmalines,Green Tourmaline,Rings For Men,Gold Rings,Oceangemsminerals,Orange Tourmaline,Brown Tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('8bbbb803-4ada-47d2-9034-0e7de6fdeb48', '12.40 Cts Bicolour Tourmaline', 'Gorgeous Bicolour Big Size Tourmaline 

12.40 Cts
17.2 x 10.3 x 7mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 174, 1, 'loose_stone', 'Tourmaline', NULL, 12.4, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/8bbbb803-4ada-47d2-9034-0e7de6fdeb48/etsy-1.jpg","https://media.gemworkers.com/items/8bbbb803-4ada-47d2-9034-0e7de6fdeb48/etsy-2.jpg","https://media.gemworkers.com/items/8bbbb803-4ada-47d2-9034-0e7de6fdeb48/etsy-3.jpg","https://media.gemworkers.com/items/8bbbb803-4ada-47d2-9034-0e7de6fdeb48/etsy-4.jpg","https://media.gemworkers.com/items/8bbbb803-4ada-47d2-9034-0e7de6fdeb48/etsy-5.jpg","https://media.gemworkers.com/items/8bbbb803-4ada-47d2-9034-0e7de6fdeb48/etsy-6.jpg","https://media.gemworkers.com/items/8bbbb803-4ada-47d2-9034-0e7de6fdeb48/etsy-7.jpg","https://media.gemworkers.com/items/8bbbb803-4ada-47d2-9034-0e7de6fdeb48/etsy-8.jpg","https://media.gemworkers.com/items/8bbbb803-4ada-47d2-9034-0e7de6fdeb48/etsy-9.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 195 USD, converted at ECB rate. Etsy tags: Emerald Cut,Bicolour Tourmaline,Tricolour Tourmaline,Pink Bicolour,Tourmaline jewellery,Natural Stone,Blue tourmalines,Green Tourmaline,Rings For Men,Gold Rings,Oceangemsminerals,Orange Tourmaline,Brown Tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('a2b3a2c9-83aa-43b8-a64d-8f4bb7698228', '2.95 Cts, Ice Blue Tourmaline Pair', 'Gorgeous Mesmerising Ice Blue Colour Natural Afghanistan Tourmaline Pair

More beautiful In real, One of a kind

2.95 Cts 
6.2x5.7x5mm

unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 322, 1, 'loose_stone', 'Tourmaline', NULL, 2.95, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/a2b3a2c9-83aa-43b8-a64d-8f4bb7698228/etsy-1.jpg","https://media.gemworkers.com/items/a2b3a2c9-83aa-43b8-a64d-8f4bb7698228/etsy-2.jpg","https://media.gemworkers.com/items/a2b3a2c9-83aa-43b8-a64d-8f4bb7698228/etsy-3.jpg","https://media.gemworkers.com/items/a2b3a2c9-83aa-43b8-a64d-8f4bb7698228/etsy-4.jpg","https://media.gemworkers.com/items/a2b3a2c9-83aa-43b8-a64d-8f4bb7698228/etsy-5.jpg","https://media.gemworkers.com/items/a2b3a2c9-83aa-43b8-a64d-8f4bb7698228/etsy-6.jpg","https://media.gemworkers.com/items/a2b3a2c9-83aa-43b8-a64d-8f4bb7698228/etsy-7.jpg","https://media.gemworkers.com/items/a2b3a2c9-83aa-43b8-a64d-8f4bb7698228/etsy-8.jpg","https://media.gemworkers.com/items/a2b3a2c9-83aa-43b8-a64d-8f4bb7698228/etsy-9.jpg","https://media.gemworkers.com/items/a2b3a2c9-83aa-43b8-a64d-8f4bb7698228/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 360 USD, converted at ECB rate. Etsy tags: Jewellery Supplies,Jewellery Making,Gold Rings,Rings For Men,Rings For Women,y2k earrings stud,Gift For Her,Tourmaline Jewellery,Natural Stone,Stud Earrings,Jewellery Stud,bicolour Tourmaline,Lagoon tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('d2b429b9-5c74-4ad0-81d4-1fda4787a1ac', '5.75 Cts Lagoon and neon blue And Green tourmalines', 'lagoon and neon blue And Green colour tourmalines

top colour high lustre and brilliance 

5.75 Cts 

5.4x5.1x4.2mm
6.8x5.8x5.1mm
8.6x5.4x4.3mm

100% natural no treatment whatsoever.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 446, 1, 'loose_stone', 'Tourmaline', NULL, 5.75, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/d2b429b9-5c74-4ad0-81d4-1fda4787a1ac/etsy-1.jpg","https://media.gemworkers.com/items/d2b429b9-5c74-4ad0-81d4-1fda4787a1ac/etsy-2.jpg","https://media.gemworkers.com/items/d2b429b9-5c74-4ad0-81d4-1fda4787a1ac/etsy-3.jpg","https://media.gemworkers.com/items/d2b429b9-5c74-4ad0-81d4-1fda4787a1ac/etsy-4.jpg","https://media.gemworkers.com/items/d2b429b9-5c74-4ad0-81d4-1fda4787a1ac/etsy-5.jpg","https://media.gemworkers.com/items/d2b429b9-5c74-4ad0-81d4-1fda4787a1ac/etsy-6.jpg","https://media.gemworkers.com/items/d2b429b9-5c74-4ad0-81d4-1fda4787a1ac/etsy-7.jpg","https://media.gemworkers.com/items/d2b429b9-5c74-4ad0-81d4-1fda4787a1ac/etsy-8.jpg","https://media.gemworkers.com/items/d2b429b9-5c74-4ad0-81d4-1fda4787a1ac/etsy-9.jpg","https://media.gemworkers.com/items/d2b429b9-5c74-4ad0-81d4-1fda4787a1ac/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 499 USD, converted at ECB rate. Etsy tags: Natural Stone,Jewellery Supplies,Jewellery Making,Jewellery Findings,y2k stud earrings,Gift For Her,Rings For Men,Rings For Women,Gold Rings,Silver Sterling,Garnet Necklace,Garnet Rings,Garnet Jewellery.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('17739335-b911-40c1-a5da-db88904355fb', '9.25 Cts Lagoon Green Colour Tourmaline', 'Mesmerising Lagoon Green Colour Afghan Tourmaline 

Ethically sourced, 

9.25 Cts 

10.9x6.6x4.9mm 
11.4x5.8x4.4mm
10.9x6.6x5.2mm

Unheated, Untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 446, 1, 'loose_stone', 'Tourmaline', NULL, 9.25, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/17739335-b911-40c1-a5da-db88904355fb/etsy-1.jpg","https://media.gemworkers.com/items/17739335-b911-40c1-a5da-db88904355fb/etsy-2.jpg","https://media.gemworkers.com/items/17739335-b911-40c1-a5da-db88904355fb/etsy-3.jpg","https://media.gemworkers.com/items/17739335-b911-40c1-a5da-db88904355fb/etsy-4.jpg","https://media.gemworkers.com/items/17739335-b911-40c1-a5da-db88904355fb/etsy-5.jpg","https://media.gemworkers.com/items/17739335-b911-40c1-a5da-db88904355fb/etsy-6.jpg","https://media.gemworkers.com/items/17739335-b911-40c1-a5da-db88904355fb/etsy-7.jpg","https://media.gemworkers.com/items/17739335-b911-40c1-a5da-db88904355fb/etsy-8.jpg","https://media.gemworkers.com/items/17739335-b911-40c1-a5da-db88904355fb/etsy-9.jpg","https://media.gemworkers.com/items/17739335-b911-40c1-a5da-db88904355fb/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 499 USD, converted at ECB rate. Etsy tags: Bluegreen Tourmaline,Blue Tourmaline,Green Tourmaline,Jewellery supplies,jewellery making,jewellery findings,jewels,Handmadejewellery,cushion cut,gift for her,natural stone,gold rings,silver stirring.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('d891b9fa-75bc-475f-a27e-464fedc00649', '7.55 Cts Blue Green Colour Tourmaline', 'Mesmerising Blue Green Colour Afghan Tourmaline 

Ethically sourced, 

best for ring

7.55 Cts 
15.5x8.2x6.3mm

Unheated, Untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 268, 1, 'loose_stone', 'Tourmaline', NULL, 7.55, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/d891b9fa-75bc-475f-a27e-464fedc00649/etsy-1.jpg","https://media.gemworkers.com/items/d891b9fa-75bc-475f-a27e-464fedc00649/etsy-2.jpg","https://media.gemworkers.com/items/d891b9fa-75bc-475f-a27e-464fedc00649/etsy-3.jpg","https://media.gemworkers.com/items/d891b9fa-75bc-475f-a27e-464fedc00649/etsy-4.jpg","https://media.gemworkers.com/items/d891b9fa-75bc-475f-a27e-464fedc00649/etsy-5.jpg","https://media.gemworkers.com/items/d891b9fa-75bc-475f-a27e-464fedc00649/etsy-6.jpg","https://media.gemworkers.com/items/d891b9fa-75bc-475f-a27e-464fedc00649/etsy-7.jpg","https://media.gemworkers.com/items/d891b9fa-75bc-475f-a27e-464fedc00649/etsy-8.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 300 USD, converted at ECB rate. Etsy tags: Bluegreen Tourmaline,Blue Tourmaline,Green Tourmaline,Jewellery supplies,jewellery making,jewellery findings,jewels,Handmadejewellery,cushion cut,gift for her,natural stone,gold rings,silver stirring.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('c2d4f3b5-afd4-479d-b479-f2f43aa52a86', '15.9 Cts Rare Bicolour Tourmaline Lot', 'Bicolour afghan tourmaline Lot combination of blue and green in emerald cut 

elegant and glowing, rare find

15.90 Cts 
12.4mm to 24mm

Unheated, Untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 714, 1, 'loose_stone', 'Tourmaline', NULL, 15.9, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/c2d4f3b5-afd4-479d-b479-f2f43aa52a86/etsy-1.jpg","https://media.gemworkers.com/items/c2d4f3b5-afd4-479d-b479-f2f43aa52a86/etsy-2.jpg","https://media.gemworkers.com/items/c2d4f3b5-afd4-479d-b479-f2f43aa52a86/etsy-3.jpg","https://media.gemworkers.com/items/c2d4f3b5-afd4-479d-b479-f2f43aa52a86/etsy-4.jpg","https://media.gemworkers.com/items/c2d4f3b5-afd4-479d-b479-f2f43aa52a86/etsy-5.jpg","https://media.gemworkers.com/items/c2d4f3b5-afd4-479d-b479-f2f43aa52a86/etsy-6.jpg","https://media.gemworkers.com/items/c2d4f3b5-afd4-479d-b479-f2f43aa52a86/etsy-7.jpg","https://media.gemworkers.com/items/c2d4f3b5-afd4-479d-b479-f2f43aa52a86/etsy-8.jpg","https://media.gemworkers.com/items/c2d4f3b5-afd4-479d-b479-f2f43aa52a86/etsy-9.jpg","https://media.gemworkers.com/items/c2d4f3b5-afd4-479d-b479-f2f43aa52a86/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 799 USD, converted at ECB rate. Etsy tags: Jewellery Making,Rings For Women,Jewellery Finding,Rings For Men,Gemstones Jewellery,Crystals,Gold Rings,Gold Ring,Jewellery Supplies,Gift For Her,Stud Earrings,Natural Stone,Bicolour Tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('58f3a7b9-5a83-4057-9ffb-5e73bb5bf876', '12.4 Cts Rare Bicolour Tourmaline', 'To All The Bicolour Lovers Here Is An Incredible Opportunity Buy A Truly Exceptional And One Of A Kind Bicolour Tourmaline

Collection worthy 

12.40 Cts 
17.2x10x7.3mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 715, 1, 'loose_stone', 'Tourmaline', NULL, 12.4, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/58f3a7b9-5a83-4057-9ffb-5e73bb5bf876/etsy-1.jpg","https://media.gemworkers.com/items/58f3a7b9-5a83-4057-9ffb-5e73bb5bf876/etsy-2.jpg","https://media.gemworkers.com/items/58f3a7b9-5a83-4057-9ffb-5e73bb5bf876/etsy-3.jpg","https://media.gemworkers.com/items/58f3a7b9-5a83-4057-9ffb-5e73bb5bf876/etsy-4.jpg","https://media.gemworkers.com/items/58f3a7b9-5a83-4057-9ffb-5e73bb5bf876/etsy-5.jpg","https://media.gemworkers.com/items/58f3a7b9-5a83-4057-9ffb-5e73bb5bf876/etsy-6.jpg","https://media.gemworkers.com/items/58f3a7b9-5a83-4057-9ffb-5e73bb5bf876/etsy-7.jpg","https://media.gemworkers.com/items/58f3a7b9-5a83-4057-9ffb-5e73bb5bf876/etsy-8.jpg","https://media.gemworkers.com/items/58f3a7b9-5a83-4057-9ffb-5e73bb5bf876/etsy-9.jpg","https://media.gemworkers.com/items/58f3a7b9-5a83-4057-9ffb-5e73bb5bf876/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 800 USD, converted at ECB rate. Etsy tags: pink tourmaline,rings for women,unique tourmaline,jewels,Handmadejewellery,gift for her,Topqualitytourmaline,Bicolour Tourmaline,Unique Bicolour,Rare Tourmaline,Oceangemsminerals,Tourmaline Pairs,Bicolour Pairs.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('3b09a4bc-e085-4a9b-8ec4-a2f004084406', '9 Cts Rare Bicolour Tourmaline Lot', 'Bicolour afghan tourmaline Lot combination of blue and green in emerald cut 

elegant and glowing, rare find

9 Cts
12.2 to 7.1mm

Unheated, Untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 268, 1, 'loose_stone', 'Tourmaline', NULL, 9, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/3b09a4bc-e085-4a9b-8ec4-a2f004084406/etsy-1.jpg","https://media.gemworkers.com/items/3b09a4bc-e085-4a9b-8ec4-a2f004084406/etsy-2.jpg","https://media.gemworkers.com/items/3b09a4bc-e085-4a9b-8ec4-a2f004084406/etsy-3.jpg","https://media.gemworkers.com/items/3b09a4bc-e085-4a9b-8ec4-a2f004084406/etsy-4.jpg","https://media.gemworkers.com/items/3b09a4bc-e085-4a9b-8ec4-a2f004084406/etsy-5.jpg","https://media.gemworkers.com/items/3b09a4bc-e085-4a9b-8ec4-a2f004084406/etsy-6.jpg","https://media.gemworkers.com/items/3b09a4bc-e085-4a9b-8ec4-a2f004084406/etsy-7.jpg","https://media.gemworkers.com/items/3b09a4bc-e085-4a9b-8ec4-a2f004084406/etsy-8.jpg","https://media.gemworkers.com/items/3b09a4bc-e085-4a9b-8ec4-a2f004084406/etsy-9.jpg","https://media.gemworkers.com/items/3b09a4bc-e085-4a9b-8ec4-a2f004084406/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 300 USD, converted at ECB rate. Etsy tags: Jewellery Making,Rings For Women,Jewellery Finding,Rings For Men,Gemstones Jewellery,Crystals,Gold Rings,Gold Ring,Jewellery Supplies,Gift For Her,Stud Earrings,Natural Stone,Bicolour Tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('9d542541-f2f4-41b2-a083-576e447ef92f', '26.15 Cts Aquamarine', 'big size Aquamarine Cushion Cut

ethically sourced 

26.15 Cts
18 x 16.8 x 12.4mm

unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 107, 1, 'loose_stone', 'Aquamarine', NULL, 26.15, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/9d542541-f2f4-41b2-a083-576e447ef92f/etsy-1.jpg","https://media.gemworkers.com/items/9d542541-f2f4-41b2-a083-576e447ef92f/etsy-2.jpg","https://media.gemworkers.com/items/9d542541-f2f4-41b2-a083-576e447ef92f/etsy-3.jpg","https://media.gemworkers.com/items/9d542541-f2f4-41b2-a083-576e447ef92f/etsy-4.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 120 USD, converted at ECB rate. Etsy tags: Santa Maria Cabochon,Blue Aquamarine,Unique Aquamarine,Rare Aquamarine,Aquamarine Cabochons,Bicolour Aquamarine,Bicolour Cabochons,Blue Cabochons,Lagoon Cabochons,Natural Stone,jewels,Oceangemsminerals,Rare Cabochons.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('50a2c565-8d7c-4614-9ba6-815a9888a9f4', '21.8 Cts Pink Morganite', 'Gorgeous Light Pink Morganites

Included But Gorgeous And Excellent Cut

Big Size

8.10 Cts ( 11.7 x 11 x 8.9mm )
13.70 Cts ( 14.6 x 12.9 x 10.3mm )

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 134, 1, 'loose_stone', 'Morganite', NULL, 21.8, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/50a2c565-8d7c-4614-9ba6-815a9888a9f4/etsy-1.jpg","https://media.gemworkers.com/items/50a2c565-8d7c-4614-9ba6-815a9888a9f4/etsy-2.jpg","https://media.gemworkers.com/items/50a2c565-8d7c-4614-9ba6-815a9888a9f4/etsy-3.jpg","https://media.gemworkers.com/items/50a2c565-8d7c-4614-9ba6-815a9888a9f4/etsy-4.jpg","https://media.gemworkers.com/items/50a2c565-8d7c-4614-9ba6-815a9888a9f4/etsy-5.jpg","https://media.gemworkers.com/items/50a2c565-8d7c-4614-9ba6-815a9888a9f4/etsy-6.jpg","https://media.gemworkers.com/items/50a2c565-8d7c-4614-9ba6-815a9888a9f4/etsy-7.jpg","https://media.gemworkers.com/items/50a2c565-8d7c-4614-9ba6-815a9888a9f4/etsy-8.jpg","https://media.gemworkers.com/items/50a2c565-8d7c-4614-9ba6-815a9888a9f4/etsy-9.jpg","https://media.gemworkers.com/items/50a2c565-8d7c-4614-9ba6-815a9888a9f4/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 150 USD, converted at ECB rate. Etsy tags: Pink Morganite,Peach Morganite,Morganite Jewellery,Aquamarine Jewellery,Natural Stone,Morganite Necklace,Morganite Rings,Gift For Her,Wedding Rings,Jewellery Supplies,Jewellery Findings,Faceted Morganite,Rare Stone.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('a0c4e1e9-9081-4f9b-b9b9-26bdd8d9df88', '1.8 Cts Blue Tourmalines', 'Gorgeous Blue Tourmaline At nill price

1.80 Cts
4 to 7mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 80, 1, 'loose_stone', 'Tourmaline', NULL, 1.8, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/a0c4e1e9-9081-4f9b-b9b9-26bdd8d9df88/etsy-1.jpg","https://media.gemworkers.com/items/a0c4e1e9-9081-4f9b-b9b9-26bdd8d9df88/etsy-2.jpg","https://media.gemworkers.com/items/a0c4e1e9-9081-4f9b-b9b9-26bdd8d9df88/etsy-3.jpg","https://media.gemworkers.com/items/a0c4e1e9-9081-4f9b-b9b9-26bdd8d9df88/etsy-4.jpg","https://media.gemworkers.com/items/a0c4e1e9-9081-4f9b-b9b9-26bdd8d9df88/etsy-5.jpg","https://media.gemworkers.com/items/a0c4e1e9-9081-4f9b-b9b9-26bdd8d9df88/etsy-6.jpg","https://media.gemworkers.com/items/a0c4e1e9-9081-4f9b-b9b9-26bdd8d9df88/etsy-7.jpg","https://media.gemworkers.com/items/a0c4e1e9-9081-4f9b-b9b9-26bdd8d9df88/etsy-8.jpg","https://media.gemworkers.com/items/a0c4e1e9-9081-4f9b-b9b9-26bdd8d9df88/etsy-9.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 90 USD, converted at ECB rate. Etsy tags: Paraiba Tourmaline,Paraiba Colour,Lagoon Tourmaline,Bluegreen Tourmaline,Blue Tourmaline,Neon Blue Tourmaline,Tourmaline Jewellery,Jewellers,Lagoon Colour,Oceangemsminerals,Ink Blue Tourmaline,Wedding Rings,Rings For Women.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('760c3779-016a-4228-9523-7ed70f6d9713', '3.25 Cts Panjsher Emeralds', 'Gorgeous Emerald Lot From Panjsher

Colour is more beautiful in real 

Kite Cut 

3.25 Cts

Unheated, untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 447, 1, 'loose_stone', 'Emerald', NULL, 3.25, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/760c3779-016a-4228-9523-7ed70f6d9713/etsy-1.jpg","https://media.gemworkers.com/items/760c3779-016a-4228-9523-7ed70f6d9713/etsy-2.jpg","https://media.gemworkers.com/items/760c3779-016a-4228-9523-7ed70f6d9713/etsy-3.jpg","https://media.gemworkers.com/items/760c3779-016a-4228-9523-7ed70f6d9713/etsy-4.jpg","https://media.gemworkers.com/items/760c3779-016a-4228-9523-7ed70f6d9713/etsy-5.jpg","https://media.gemworkers.com/items/760c3779-016a-4228-9523-7ed70f6d9713/etsy-6.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 500 USD, converted at ECB rate. Etsy tags: Emerald,Emerald supplies,Emerald rings,Emerald earrings,Oceangemsminerals,Gift for her,Natural stone,Jewellery making,Rings for women,Rings for men,Emerald Jewellery,Bicolour Emerald,Emerald Cabochons.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('8f34b142-5eb4-496f-964b-c905f32cf3a2', '24.60 Blue Bicolour Tourmaline Lot', 'Bicolour Blue Mesmerising Afghan Tourmaline Lot

24.60 Cts
10 to 9mm

glowing 

unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 724, 1, 'loose_stone', 'Tourmaline', NULL, NULL, NULL, 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/8f34b142-5eb4-496f-964b-c905f32cf3a2/etsy-1.jpg","https://media.gemworkers.com/items/8f34b142-5eb4-496f-964b-c905f32cf3a2/etsy-2.jpg","https://media.gemworkers.com/items/8f34b142-5eb4-496f-964b-c905f32cf3a2/etsy-3.jpg","https://media.gemworkers.com/items/8f34b142-5eb4-496f-964b-c905f32cf3a2/etsy-4.jpg","https://media.gemworkers.com/items/8f34b142-5eb4-496f-964b-c905f32cf3a2/etsy-5.jpg","https://media.gemworkers.com/items/8f34b142-5eb4-496f-964b-c905f32cf3a2/etsy-6.jpg","https://media.gemworkers.com/items/8f34b142-5eb4-496f-964b-c905f32cf3a2/etsy-7.jpg","https://media.gemworkers.com/items/8f34b142-5eb4-496f-964b-c905f32cf3a2/etsy-8.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 810 USD, converted at ECB rate. Etsy tags: Bicolour Tourmaline,Blue Tourmaline,Lagoon Tourmaline,Neon Tourmaline,Tourmaline jewellery,gift for her,natural stone,Tourmaline Rings,tourmaline necklace,rings for men,rings for women,jewellery making,jewellery supplies.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('99d6db87-3a5a-4035-b1df-16e08fe925ca', '38.40 Cts Bicolour Tourmaline Lot', 'Gorgeous TriColour Tourmaline Lot

Exceptional And Unique 

Big Sizes

38.40 Cts
14.8 to 8.1mm

no treatment whatsoever', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 581, 1, 'loose_stone', 'Tourmaline', NULL, 38.4, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/99d6db87-3a5a-4035-b1df-16e08fe925ca/etsy-1.jpg","https://media.gemworkers.com/items/99d6db87-3a5a-4035-b1df-16e08fe925ca/etsy-2.jpg","https://media.gemworkers.com/items/99d6db87-3a5a-4035-b1df-16e08fe925ca/etsy-3.jpg","https://media.gemworkers.com/items/99d6db87-3a5a-4035-b1df-16e08fe925ca/etsy-4.jpg","https://media.gemworkers.com/items/99d6db87-3a5a-4035-b1df-16e08fe925ca/etsy-5.jpg","https://media.gemworkers.com/items/99d6db87-3a5a-4035-b1df-16e08fe925ca/etsy-6.jpg","https://media.gemworkers.com/items/99d6db87-3a5a-4035-b1df-16e08fe925ca/etsy-7.jpg","https://media.gemworkers.com/items/99d6db87-3a5a-4035-b1df-16e08fe925ca/etsy-8.jpg","https://media.gemworkers.com/items/99d6db87-3a5a-4035-b1df-16e08fe925ca/etsy-9.jpg","https://media.gemworkers.com/items/99d6db87-3a5a-4035-b1df-16e08fe925ca/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 650 USD, converted at ECB rate. Etsy tags: Tourmaline Jewellery,Tourmaline Rings,Natural Stone,Bicolour Tourmaline,Loose gemstones,Gold Rings,Rings For women,Rings For Men,y2k earrings stud,bicolour stone,Oceangemsminerals,Tricolour Tourmaline,Tourmaline Pairs.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('a078db1d-fd54-4ced-9e21-11f2c148b4a0', '29.10 Cts Mix Bicolour Tourmaline Lot', 'To All The Bicolour Lovers Here Is An Incredible Opportunity Buy A Truly Exceptional And One Of A Kind Bicolour And Tricolour Tourmaline Lot

Mix Bicolours And Tricolours

29.10 Cts
10.8 to 7.2mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 536, 1, 'loose_stone', 'Tourmaline', NULL, 29.1, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/a078db1d-fd54-4ced-9e21-11f2c148b4a0/etsy-1.jpg","https://media.gemworkers.com/items/a078db1d-fd54-4ced-9e21-11f2c148b4a0/etsy-2.jpg","https://media.gemworkers.com/items/a078db1d-fd54-4ced-9e21-11f2c148b4a0/etsy-3.jpg","https://media.gemworkers.com/items/a078db1d-fd54-4ced-9e21-11f2c148b4a0/etsy-4.jpg","https://media.gemworkers.com/items/a078db1d-fd54-4ced-9e21-11f2c148b4a0/etsy-5.jpg","https://media.gemworkers.com/items/a078db1d-fd54-4ced-9e21-11f2c148b4a0/etsy-6.jpg","https://media.gemworkers.com/items/a078db1d-fd54-4ced-9e21-11f2c148b4a0/etsy-7.jpg","https://media.gemworkers.com/items/a078db1d-fd54-4ced-9e21-11f2c148b4a0/etsy-8.jpg","https://media.gemworkers.com/items/a078db1d-fd54-4ced-9e21-11f2c148b4a0/etsy-9.jpg","https://media.gemworkers.com/items/a078db1d-fd54-4ced-9e21-11f2c148b4a0/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 600 USD, converted at ECB rate. Etsy tags: pink tourmaline,rings for women,unique tourmaline,Handmadejewellery,gift for her,Bicolour Tourmaline,Unique Bicolour,Rare Tourmaline,Oceangemsminerals,Tourmaline Pairs,Bicolour Pairs,Canary Tourmaline,Mix Bicolour Lot.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('36c3e9d5-70c1-432d-8fb9-24f1c8158eca', '29.10 Cts Tricolour Tourmaline Lot', 'Gorgeous TriColour Tourmaline Lot

Exceptional And Unique 

Big Sizes

29.10 Cts
15.8 to 7.8mm

no treatment whatsoever', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 581, 1, 'loose_stone', 'Tourmaline', NULL, 29.1, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/36c3e9d5-70c1-432d-8fb9-24f1c8158eca/etsy-1.jpg","https://media.gemworkers.com/items/36c3e9d5-70c1-432d-8fb9-24f1c8158eca/etsy-2.jpg","https://media.gemworkers.com/items/36c3e9d5-70c1-432d-8fb9-24f1c8158eca/etsy-3.jpg","https://media.gemworkers.com/items/36c3e9d5-70c1-432d-8fb9-24f1c8158eca/etsy-4.jpg","https://media.gemworkers.com/items/36c3e9d5-70c1-432d-8fb9-24f1c8158eca/etsy-5.jpg","https://media.gemworkers.com/items/36c3e9d5-70c1-432d-8fb9-24f1c8158eca/etsy-6.jpg","https://media.gemworkers.com/items/36c3e9d5-70c1-432d-8fb9-24f1c8158eca/etsy-7.jpg","https://media.gemworkers.com/items/36c3e9d5-70c1-432d-8fb9-24f1c8158eca/etsy-8.jpg","https://media.gemworkers.com/items/36c3e9d5-70c1-432d-8fb9-24f1c8158eca/etsy-9.jpg","https://media.gemworkers.com/items/36c3e9d5-70c1-432d-8fb9-24f1c8158eca/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 650 USD, converted at ECB rate. Etsy tags: Tourmaline Jewellery,Tourmaline Rings,Natural Stone,Bicolour Tourmaline,Loose gemstones,Gold Rings,Rings For women,Rings For Men,y2k earrings stud,bicolour stone,Oceangemsminerals,Tricolour Tourmaline,Tourmaline Pairs.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('b3104b8b-596e-4407-bddf-e6d6d00267ea', '27.20 Cts  Bicolour Afghan Tourmaline lot', 'Gorgeous Mesmerising Natural Bicolour Afghan Tourmalines

Saturated Colour.

27.20 Cts
11.9 to 6.4mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 447, 1, 'loose_stone', 'Tourmaline', NULL, 27.2, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/b3104b8b-596e-4407-bddf-e6d6d00267ea/etsy-1.jpg","https://media.gemworkers.com/items/b3104b8b-596e-4407-bddf-e6d6d00267ea/etsy-2.jpg","https://media.gemworkers.com/items/b3104b8b-596e-4407-bddf-e6d6d00267ea/etsy-3.jpg","https://media.gemworkers.com/items/b3104b8b-596e-4407-bddf-e6d6d00267ea/etsy-4.jpg","https://media.gemworkers.com/items/b3104b8b-596e-4407-bddf-e6d6d00267ea/etsy-5.jpg","https://media.gemworkers.com/items/b3104b8b-596e-4407-bddf-e6d6d00267ea/etsy-6.jpg","https://media.gemworkers.com/items/b3104b8b-596e-4407-bddf-e6d6d00267ea/etsy-7.jpg","https://media.gemworkers.com/items/b3104b8b-596e-4407-bddf-e6d6d00267ea/etsy-8.jpg","https://media.gemworkers.com/items/b3104b8b-596e-4407-bddf-e6d6d00267ea/etsy-9.jpg","https://media.gemworkers.com/items/b3104b8b-596e-4407-bddf-e6d6d00267ea/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 500 USD, converted at ECB rate. Etsy tags: Tourmaline Rings,rings for women,rings for men,jewellery making,jewellery findings,gift for her,natural stone,Oceangemsminerals,apple green colour,Bicolour Tourmaline,Natural Bicolour,Unheated Tourmaline,Lipstick Tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('936ca1a4-4edc-4996-be6a-7d9a2db34cce', '13.60 Cts Lagoon Colour Tourmalines', 'Natural Seafoam Paraiba Colour Tourmaline 

More Beautiful In Real.

13.60 Cts 
8.8 to 4.9mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 268, 1, 'loose_stone', 'Tourmaline', NULL, 13.6, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/936ca1a4-4edc-4996-be6a-7d9a2db34cce/etsy-1.jpg","https://media.gemworkers.com/items/936ca1a4-4edc-4996-be6a-7d9a2db34cce/etsy-2.jpg","https://media.gemworkers.com/items/936ca1a4-4edc-4996-be6a-7d9a2db34cce/etsy-3.jpg","https://media.gemworkers.com/items/936ca1a4-4edc-4996-be6a-7d9a2db34cce/etsy-4.jpg","https://media.gemworkers.com/items/936ca1a4-4edc-4996-be6a-7d9a2db34cce/etsy-5.jpg","https://media.gemworkers.com/items/936ca1a4-4edc-4996-be6a-7d9a2db34cce/etsy-6.jpg","https://media.gemworkers.com/items/936ca1a4-4edc-4996-be6a-7d9a2db34cce/etsy-7.jpg","https://media.gemworkers.com/items/936ca1a4-4edc-4996-be6a-7d9a2db34cce/etsy-8.jpg","https://media.gemworkers.com/items/936ca1a4-4edc-4996-be6a-7d9a2db34cce/etsy-9.jpg","https://media.gemworkers.com/items/936ca1a4-4edc-4996-be6a-7d9a2db34cce/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 300 USD, converted at ECB rate. Etsy tags: Paraiba Tourmaline,Paraiba Colour,Lagoon Tourmaline,Bluegreen Tourmaline,Blue Tourmaline,Neon Blue Tourmaline,Tourmaline Jewellery,Jewellers,Lagoon Colour,Oceangemsminerals,Ink Blue Tourmaline,Wedding Rings,Rings For Women.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('46c0f6cc-46c0-496a-81f1-644d71b6190f', '8.9 Cts Watermelon Tourmaline Lot', 'Sweet Bicolour Tourmaline Almost Calibrated Size

Unique And Rare Colour

8.90 Cts 
6.8 to 6mm

No treatment.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 322, 1, 'loose_stone', 'Tourmaline', 'Watermelon', 8.9, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/46c0f6cc-46c0-496a-81f1-644d71b6190f/etsy-1.jpg","https://media.gemworkers.com/items/46c0f6cc-46c0-496a-81f1-644d71b6190f/etsy-2.jpg","https://media.gemworkers.com/items/46c0f6cc-46c0-496a-81f1-644d71b6190f/etsy-3.jpg","https://media.gemworkers.com/items/46c0f6cc-46c0-496a-81f1-644d71b6190f/etsy-4.jpg","https://media.gemworkers.com/items/46c0f6cc-46c0-496a-81f1-644d71b6190f/etsy-5.jpg","https://media.gemworkers.com/items/46c0f6cc-46c0-496a-81f1-644d71b6190f/etsy-6.jpg","https://media.gemworkers.com/items/46c0f6cc-46c0-496a-81f1-644d71b6190f/etsy-7.jpg","https://media.gemworkers.com/items/46c0f6cc-46c0-496a-81f1-644d71b6190f/etsy-8.jpg","https://media.gemworkers.com/items/46c0f6cc-46c0-496a-81f1-644d71b6190f/etsy-9.jpg","https://media.gemworkers.com/items/46c0f6cc-46c0-496a-81f1-644d71b6190f/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 360 USD, converted at ECB rate. Etsy tags: Tourmaline Jewellery,Tourmaline Earrings,Earrings Stud,y2k earrings stud,Gold Rings,Natural Stone,Gift For Her,Rings For Men,Oceangemsminerals,lagoon tourmaline,tourmaline pairs,bicolour tourmaline,Watermelon Bicolour.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('cf8365ce-fca3-4aaf-ba66-f6187f491fd7', '2.1 Cts Pink Bicolour Tourmaline Pair', 'Natural Pink bicolour mesmerising tourmaline Pair

2.10 Cts
5.1 x 5.2 x 4mm

unheated, untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 178, 1, 'loose_stone', 'Tourmaline', NULL, 2.1, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/cf8365ce-fca3-4aaf-ba66-f6187f491fd7/etsy-1.jpg","https://media.gemworkers.com/items/cf8365ce-fca3-4aaf-ba66-f6187f491fd7/etsy-2.jpg","https://media.gemworkers.com/items/cf8365ce-fca3-4aaf-ba66-f6187f491fd7/etsy-3.jpg","https://media.gemworkers.com/items/cf8365ce-fca3-4aaf-ba66-f6187f491fd7/etsy-4.jpg","https://media.gemworkers.com/items/cf8365ce-fca3-4aaf-ba66-f6187f491fd7/etsy-5.jpg","https://media.gemworkers.com/items/cf8365ce-fca3-4aaf-ba66-f6187f491fd7/etsy-6.jpg","https://media.gemworkers.com/items/cf8365ce-fca3-4aaf-ba66-f6187f491fd7/etsy-7.jpg","https://media.gemworkers.com/items/cf8365ce-fca3-4aaf-ba66-f6187f491fd7/etsy-8.jpg","https://media.gemworkers.com/items/cf8365ce-fca3-4aaf-ba66-f6187f491fd7/etsy-9.jpg","https://media.gemworkers.com/items/cf8365ce-fca3-4aaf-ba66-f6187f491fd7/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 199 USD, converted at ECB rate. Etsy tags: Rings for women,rings for men,natural stone,gift for her,jewellery making,jewellery supplies,jewellery findings,bicolour tourmaline,pink tourmaline,stud jewellery,tourmaline emerald,emerald cut,green tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('d8fdd3dc-a5fa-41f8-abb7-ea26c5e1e746', '31.55 Blue Bicolour Tourmaline Lot', 'Bicolour Blue Mesmerising Afghan Tourmaline Lot

31.55 Cts
11.2 to 6.8mm

glowing 

unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 733, 1, 'loose_stone', 'Tourmaline', NULL, NULL, NULL, 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/d8fdd3dc-a5fa-41f8-abb7-ea26c5e1e746/etsy-1.jpg","https://media.gemworkers.com/items/d8fdd3dc-a5fa-41f8-abb7-ea26c5e1e746/etsy-2.jpg","https://media.gemworkers.com/items/d8fdd3dc-a5fa-41f8-abb7-ea26c5e1e746/etsy-3.jpg","https://media.gemworkers.com/items/d8fdd3dc-a5fa-41f8-abb7-ea26c5e1e746/etsy-4.jpg","https://media.gemworkers.com/items/d8fdd3dc-a5fa-41f8-abb7-ea26c5e1e746/etsy-5.jpg","https://media.gemworkers.com/items/d8fdd3dc-a5fa-41f8-abb7-ea26c5e1e746/etsy-6.jpg","https://media.gemworkers.com/items/d8fdd3dc-a5fa-41f8-abb7-ea26c5e1e746/etsy-7.jpg","https://media.gemworkers.com/items/d8fdd3dc-a5fa-41f8-abb7-ea26c5e1e746/etsy-8.jpg","https://media.gemworkers.com/items/d8fdd3dc-a5fa-41f8-abb7-ea26c5e1e746/etsy-9.jpg","https://media.gemworkers.com/items/d8fdd3dc-a5fa-41f8-abb7-ea26c5e1e746/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 820 USD, converted at ECB rate. Etsy tags: Bicolour Tourmaline,Blue Tourmaline,Lagoon Tourmaline,Neon Tourmaline,Tourmaline jewellery,gift for her,natural stone,Tourmaline Rings,tourmaline necklace,rings for men,rings for women,jewellery making,jewellery supplies.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('9d82df42-fd81-4e04-b9b8-0a7b95f12eaf', '14 Cts Tricolour Tourmaline Lot', 'To All The Bicolour Lovers Here Is An Incredible Opportunity Buy A Truly Exceptional And One Of A Kind Bicolour And Tricolour Tourmaline Lot

Mix Bicolours And Tricolours

14 Cts
9.4 to 5.4mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 536, 1, 'loose_stone', 'Tourmaline', NULL, 14, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/9d82df42-fd81-4e04-b9b8-0a7b95f12eaf/etsy-1.jpg","https://media.gemworkers.com/items/9d82df42-fd81-4e04-b9b8-0a7b95f12eaf/etsy-2.jpg","https://media.gemworkers.com/items/9d82df42-fd81-4e04-b9b8-0a7b95f12eaf/etsy-3.jpg","https://media.gemworkers.com/items/9d82df42-fd81-4e04-b9b8-0a7b95f12eaf/etsy-4.jpg","https://media.gemworkers.com/items/9d82df42-fd81-4e04-b9b8-0a7b95f12eaf/etsy-5.jpg","https://media.gemworkers.com/items/9d82df42-fd81-4e04-b9b8-0a7b95f12eaf/etsy-6.jpg","https://media.gemworkers.com/items/9d82df42-fd81-4e04-b9b8-0a7b95f12eaf/etsy-7.jpg","https://media.gemworkers.com/items/9d82df42-fd81-4e04-b9b8-0a7b95f12eaf/etsy-8.jpg","https://media.gemworkers.com/items/9d82df42-fd81-4e04-b9b8-0a7b95f12eaf/etsy-9.jpg","https://media.gemworkers.com/items/9d82df42-fd81-4e04-b9b8-0a7b95f12eaf/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 600 USD, converted at ECB rate. Etsy tags: pink tourmaline,rings for women,unique tourmaline,Handmadejewellery,gift for her,Bicolour Tourmaline,Unique Bicolour,Rare Tourmaline,Oceangemsminerals,Tourmaline Pairs,Bicolour Pairs,Canary Tourmaline,Mix Bicolour Lot.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('7002af5a-27e8-4ecf-a284-3392db26bae5', '22.55 Cts Mix Bicolour Tourmaline Lot', 'To All The Bicolour Lovers Here Is An Incredible Opportunity Buy A Truly Exceptional And One Of A Kind Bicolour And Tricolour Tourmaline Lot

Mix Bicolours And Tricolours

24.55 Cts
14.7 to 8.4mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 536, 1, 'loose_stone', 'Tourmaline', NULL, 22.55, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/7002af5a-27e8-4ecf-a284-3392db26bae5/etsy-1.jpg","https://media.gemworkers.com/items/7002af5a-27e8-4ecf-a284-3392db26bae5/etsy-2.jpg","https://media.gemworkers.com/items/7002af5a-27e8-4ecf-a284-3392db26bae5/etsy-3.jpg","https://media.gemworkers.com/items/7002af5a-27e8-4ecf-a284-3392db26bae5/etsy-4.jpg","https://media.gemworkers.com/items/7002af5a-27e8-4ecf-a284-3392db26bae5/etsy-5.jpg","https://media.gemworkers.com/items/7002af5a-27e8-4ecf-a284-3392db26bae5/etsy-6.jpg","https://media.gemworkers.com/items/7002af5a-27e8-4ecf-a284-3392db26bae5/etsy-7.jpg","https://media.gemworkers.com/items/7002af5a-27e8-4ecf-a284-3392db26bae5/etsy-8.jpg","https://media.gemworkers.com/items/7002af5a-27e8-4ecf-a284-3392db26bae5/etsy-9.jpg","https://media.gemworkers.com/items/7002af5a-27e8-4ecf-a284-3392db26bae5/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 600 USD, converted at ECB rate. Etsy tags: pink tourmaline,rings for women,unique tourmaline,Handmadejewellery,gift for her,Bicolour Tourmaline,Unique Bicolour,Rare Tourmaline,Oceangemsminerals,Tourmaline Pairs,Bicolour Pairs,Canary Tourmaline,Mix Bicolour Lot.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('e5021f97-bd82-4a4b-8a98-0730d8389bcf', 'Lustrous Teardrop Kunzite Gemstone - 31.45 Cts', 'Gorgeous Teardrop shape lustrous Kunzite 

31.45 Cts
22.8 x 18.3 x 12.8mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 277, 1, 'loose_stone', 'Kunzite', NULL, 31.45, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/e5021f97-bd82-4a4b-8a98-0730d8389bcf/etsy-1.jpg","https://media.gemworkers.com/items/e5021f97-bd82-4a4b-8a98-0730d8389bcf/etsy-2.jpg","https://media.gemworkers.com/items/e5021f97-bd82-4a4b-8a98-0730d8389bcf/etsy-3.jpg","https://media.gemworkers.com/items/e5021f97-bd82-4a4b-8a98-0730d8389bcf/etsy-4.jpg","https://media.gemworkers.com/items/e5021f97-bd82-4a4b-8a98-0730d8389bcf/etsy-5.jpg","https://media.gemworkers.com/items/e5021f97-bd82-4a4b-8a98-0730d8389bcf/etsy-6.jpg","https://media.gemworkers.com/items/e5021f97-bd82-4a4b-8a98-0730d8389bcf/etsy-7.jpg","https://media.gemworkers.com/items/e5021f97-bd82-4a4b-8a98-0730d8389bcf/etsy-8.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 310 USD, converted at ECB rate. Etsy tags: Terminated Crystals,Jewellery Making,Aquamarine Specimen,Collectors,AquamarineCollection,Blue Aquamarine,Green Aquamarine,Gift For Her,Natural Stone,Kunzite Crystal,Heated Kunzite,Rough Kunzite,Kunzite Jewellery.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('b6d0cbe2-51cb-4dc7-8537-bd188c555b29', '6.75 Cts Dark Green Tourmaline', 'Gorgeous Mesmerising Dark Green Cool Colour Afghan Tourmaline 

better looking in real

6.75 Cts
12.3 x 8.8 x 6.7mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 179, 1, 'loose_stone', 'Tourmaline', NULL, 6.75, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/b6d0cbe2-51cb-4dc7-8537-bd188c555b29/etsy-1.jpg","https://media.gemworkers.com/items/b6d0cbe2-51cb-4dc7-8537-bd188c555b29/etsy-2.jpg","https://media.gemworkers.com/items/b6d0cbe2-51cb-4dc7-8537-bd188c555b29/etsy-3.jpg","https://media.gemworkers.com/items/b6d0cbe2-51cb-4dc7-8537-bd188c555b29/etsy-4.jpg","https://media.gemworkers.com/items/b6d0cbe2-51cb-4dc7-8537-bd188c555b29/etsy-5.jpg","https://media.gemworkers.com/items/b6d0cbe2-51cb-4dc7-8537-bd188c555b29/etsy-6.jpg","https://media.gemworkers.com/items/b6d0cbe2-51cb-4dc7-8537-bd188c555b29/etsy-7.jpg","https://media.gemworkers.com/items/b6d0cbe2-51cb-4dc7-8537-bd188c555b29/etsy-8.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 200 USD, converted at ECB rate. Etsy tags: Tourmaline Jewellery,Jewellery Supplies,Jewellery Making,Jewellery Findings,Tourmaline Earrings,Earrings Stud,y2k earrings stud,Gold Rings,Natural Stone,Gift For Her,Rings For Men,Rings For Women,Chrome Tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('9ac2fd90-0d7f-46ed-bf38-b5ca7ccebe3c', '15 Cts Mix Bicolour Tourmaline Lot', 'To All The Bicolour Lovers Here Is An Incredible Opportunity Buy A Truly Exceptional And One Of A Kind Bicolour Tourmaline Lot

Mix Bicolours

15 Cts
8.6 to 6.3mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 161, 1, 'loose_stone', 'Tourmaline', NULL, 15, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/9ac2fd90-0d7f-46ed-bf38-b5ca7ccebe3c/etsy-1.jpg","https://media.gemworkers.com/items/9ac2fd90-0d7f-46ed-bf38-b5ca7ccebe3c/etsy-2.jpg","https://media.gemworkers.com/items/9ac2fd90-0d7f-46ed-bf38-b5ca7ccebe3c/etsy-3.jpg","https://media.gemworkers.com/items/9ac2fd90-0d7f-46ed-bf38-b5ca7ccebe3c/etsy-4.jpg","https://media.gemworkers.com/items/9ac2fd90-0d7f-46ed-bf38-b5ca7ccebe3c/etsy-5.jpg","https://media.gemworkers.com/items/9ac2fd90-0d7f-46ed-bf38-b5ca7ccebe3c/etsy-6.jpg","https://media.gemworkers.com/items/9ac2fd90-0d7f-46ed-bf38-b5ca7ccebe3c/etsy-7.jpg","https://media.gemworkers.com/items/9ac2fd90-0d7f-46ed-bf38-b5ca7ccebe3c/etsy-8.jpg","https://media.gemworkers.com/items/9ac2fd90-0d7f-46ed-bf38-b5ca7ccebe3c/etsy-9.jpg","https://media.gemworkers.com/items/9ac2fd90-0d7f-46ed-bf38-b5ca7ccebe3c/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 180 USD, converted at ECB rate. Etsy tags: pink tourmaline,rings for women,unique tourmaline,jewels,Handmadejewellery,gift for her,Bicolour Tourmaline,Unique Bicolour,Rare Tourmaline,Oceangemsminerals,Tourmaline Pairs,Bicolour Pairs,Canary Tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('aff494fb-300d-4871-bf07-5e469d7a5abf', '16.75 Cts Mix Bicolour Tourmaline Lot', 'To All The Bicolour Lovers Here Is An Incredible Opportunity Buy A Truly Exceptional And One Of A Kind Bicolour Tourmaline Lot

Mix Bicolours

16.75 Cts
12.3 to 5.5mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 205, 1, 'loose_stone', 'Tourmaline', NULL, 16.75, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/aff494fb-300d-4871-bf07-5e469d7a5abf/etsy-1.jpg","https://media.gemworkers.com/items/aff494fb-300d-4871-bf07-5e469d7a5abf/etsy-2.jpg","https://media.gemworkers.com/items/aff494fb-300d-4871-bf07-5e469d7a5abf/etsy-3.jpg","https://media.gemworkers.com/items/aff494fb-300d-4871-bf07-5e469d7a5abf/etsy-4.jpg","https://media.gemworkers.com/items/aff494fb-300d-4871-bf07-5e469d7a5abf/etsy-5.jpg","https://media.gemworkers.com/items/aff494fb-300d-4871-bf07-5e469d7a5abf/etsy-6.jpg","https://media.gemworkers.com/items/aff494fb-300d-4871-bf07-5e469d7a5abf/etsy-7.jpg","https://media.gemworkers.com/items/aff494fb-300d-4871-bf07-5e469d7a5abf/etsy-8.jpg","https://media.gemworkers.com/items/aff494fb-300d-4871-bf07-5e469d7a5abf/etsy-9.jpg","https://media.gemworkers.com/items/aff494fb-300d-4871-bf07-5e469d7a5abf/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 230 USD, converted at ECB rate. Etsy tags: pink tourmaline,rings for women,unique tourmaline,jewels,Handmadejewellery,gift for her,Bicolour Tourmaline,Unique Bicolour,Rare Tourmaline,Oceangemsminerals,Tourmaline Pairs,Bicolour Pairs,Canary Tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('ecfaf2d5-a74e-44c8-b657-04fa25b17ae8', '4 Cts Pink And Blue Green Tourmaline.', 'gorgeous Tourmalines

it was a very random purchase it was in rough form looking very bad and was dusty. 
It turned out so good after cutting I couldn’t believe it’s mine.

4 Cts
5 to 7.5mm

I will list very low price. The stones are worth more', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 107, 1, 'loose_stone', 'Tourmaline', NULL, 4, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/ecfaf2d5-a74e-44c8-b657-04fa25b17ae8/etsy-1.jpg","https://media.gemworkers.com/items/ecfaf2d5-a74e-44c8-b657-04fa25b17ae8/etsy-2.jpg","https://media.gemworkers.com/items/ecfaf2d5-a74e-44c8-b657-04fa25b17ae8/etsy-3.jpg","https://media.gemworkers.com/items/ecfaf2d5-a74e-44c8-b657-04fa25b17ae8/etsy-4.jpg","https://media.gemworkers.com/items/ecfaf2d5-a74e-44c8-b657-04fa25b17ae8/etsy-5.jpg","https://media.gemworkers.com/items/ecfaf2d5-a74e-44c8-b657-04fa25b17ae8/etsy-6.jpg","https://media.gemworkers.com/items/ecfaf2d5-a74e-44c8-b657-04fa25b17ae8/etsy-7.jpg","https://media.gemworkers.com/items/ecfaf2d5-a74e-44c8-b657-04fa25b17ae8/etsy-8.jpg","https://media.gemworkers.com/items/ecfaf2d5-a74e-44c8-b657-04fa25b17ae8/etsy-9.jpg","https://media.gemworkers.com/items/ecfaf2d5-a74e-44c8-b657-04fa25b17ae8/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 120 USD, converted at ECB rate. Etsy tags: Pink Tourmaline,Baby Pink Tourmaline,Lagoon Tourmaline,Bluegreen Tourmaline,Neon Blue Tourmaline,Bubble Gum Pink,Oceangemsminerals,Tourmaline Jewellery,Tourmaline Lots,Tourmaline Lot,Jewellery Making,Ink Blue Tourmaline,Rare Tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('c0f6956b-1ba6-49db-b380-1149a2d605c4', '2.30 Cts Blue Tourmalines', 'Bicolour And Blue Colour Tourmaline Emerald Cut 

rare find

2.30 Cts
7.8 to 9mm

No Treatment Whatsoever.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 116, 1, 'loose_stone', 'Tourmaline', NULL, 2.3, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/c0f6956b-1ba6-49db-b380-1149a2d605c4/etsy-1.jpg","https://media.gemworkers.com/items/c0f6956b-1ba6-49db-b380-1149a2d605c4/etsy-2.jpg","https://media.gemworkers.com/items/c0f6956b-1ba6-49db-b380-1149a2d605c4/etsy-3.jpg","https://media.gemworkers.com/items/c0f6956b-1ba6-49db-b380-1149a2d605c4/etsy-4.jpg","https://media.gemworkers.com/items/c0f6956b-1ba6-49db-b380-1149a2d605c4/etsy-5.jpg","https://media.gemworkers.com/items/c0f6956b-1ba6-49db-b380-1149a2d605c4/etsy-6.jpg","https://media.gemworkers.com/items/c0f6956b-1ba6-49db-b380-1149a2d605c4/etsy-7.jpg","https://media.gemworkers.com/items/c0f6956b-1ba6-49db-b380-1149a2d605c4/etsy-8.jpg","https://media.gemworkers.com/items/c0f6956b-1ba6-49db-b380-1149a2d605c4/etsy-9.jpg","https://media.gemworkers.com/items/c0f6956b-1ba6-49db-b380-1149a2d605c4/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 130 USD, converted at ECB rate. Etsy tags: Emerald Cut,EmeraldCutTourmaline,Jewellery making,earrings stud,Tourmaline Lot,Blue Tourmaline,Lagoon Tourmaline,Neon Blue,neon blue tourmaline,Rings For Men,Tourmalines,Ink Blue Tourmaline,Oceangemsminerals.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('c4db70a1-a990-4b30-970d-478ab25e74b4', '5.65 Cts, Lagoon Green Tourmaline', 'Gorgeous Mesmerising Blue Green Afghan Tourmaline 

Unique Colour 

5.65 Cts
10.9 x 9.4 x 7mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 447, 1, 'loose_stone', 'Tourmaline', NULL, 5.65, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/c4db70a1-a990-4b30-970d-478ab25e74b4/etsy-1.jpg","https://media.gemworkers.com/items/c4db70a1-a990-4b30-970d-478ab25e74b4/etsy-2.jpg","https://media.gemworkers.com/items/c4db70a1-a990-4b30-970d-478ab25e74b4/etsy-3.jpg","https://media.gemworkers.com/items/c4db70a1-a990-4b30-970d-478ab25e74b4/etsy-4.jpg","https://media.gemworkers.com/items/c4db70a1-a990-4b30-970d-478ab25e74b4/etsy-5.jpg","https://media.gemworkers.com/items/c4db70a1-a990-4b30-970d-478ab25e74b4/etsy-6.jpg","https://media.gemworkers.com/items/c4db70a1-a990-4b30-970d-478ab25e74b4/etsy-7.jpg","https://media.gemworkers.com/items/c4db70a1-a990-4b30-970d-478ab25e74b4/etsy-8.jpg","https://media.gemworkers.com/items/c4db70a1-a990-4b30-970d-478ab25e74b4/etsy-9.jpg","https://media.gemworkers.com/items/c4db70a1-a990-4b30-970d-478ab25e74b4/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 500 USD, converted at ECB rate. Etsy tags: BlueGreen Tourmaline,Blue Tourmaline,Green Tourmaline,Lagoon Tourmaline,Neon Tourmaline,Tourmaline Rings,rings for women,rings for men,jewellery making,jewellery supplies,jewellery findings,gift for her,natural stone.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('d1f5f55d-9de4-430e-b7f3-7938827b30ab', '3.80 Cts Indigo Tourmaline', 'Bright Indigo Afghan Tourmaline ✨ 

Included But Fantastic Colour

3.80 Cts 

Size:13x6.8x4.4mm

Exceptional Colour Very Rare To Be Find, 

More Beautiful In Real.

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 535, 1, 'loose_stone', 'Tourmaline', NULL, 3.8, 'ct', 'Afghanistan', NULL, '13x6.8x4.4', '["https://media.gemworkers.com/items/d1f5f55d-9de4-430e-b7f3-7938827b30ab/etsy-1.jpg","https://media.gemworkers.com/items/d1f5f55d-9de4-430e-b7f3-7938827b30ab/etsy-2.jpg","https://media.gemworkers.com/items/d1f5f55d-9de4-430e-b7f3-7938827b30ab/etsy-3.jpg","https://media.gemworkers.com/items/d1f5f55d-9de4-430e-b7f3-7938827b30ab/etsy-4.jpg","https://media.gemworkers.com/items/d1f5f55d-9de4-430e-b7f3-7938827b30ab/etsy-5.jpg","https://media.gemworkers.com/items/d1f5f55d-9de4-430e-b7f3-7938827b30ab/etsy-6.jpg","https://media.gemworkers.com/items/d1f5f55d-9de4-430e-b7f3-7938827b30ab/etsy-7.jpg","https://media.gemworkers.com/items/d1f5f55d-9de4-430e-b7f3-7938827b30ab/etsy-8.jpg","https://media.gemworkers.com/items/d1f5f55d-9de4-430e-b7f3-7938827b30ab/etsy-9.jpg","https://media.gemworkers.com/items/d1f5f55d-9de4-430e-b7f3-7938827b30ab/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 599 USD, converted at ECB rate. Etsy tags: Paraiba Tourmaline,Paraiba Colour,Lagoon Tourmaline,Bluegreen Tourmaline,Blue Tourmaline,Neon Blue Tourmaline,Tourmaline Jewellery,Jewellers,Lagoon Colour,Oceangemsminerals,Ink Blue Tourmaline,Wedding Rings,Rings For Women.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('27760205-aaa0-4345-8652-e344baee7d21', '4.5 Cts Blue Green Tourmaline', 'Mesmerising Blue Green Colour Tourmaline

Very Beautiful And High Lustre

Vibrant Colour

Loupe Clean 

4.50 Cts 
13.2x6.7x5.1mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 536, 1, 'loose_stone', 'Tourmaline', NULL, 4.5, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/27760205-aaa0-4345-8652-e344baee7d21/etsy-1.jpg","https://media.gemworkers.com/items/27760205-aaa0-4345-8652-e344baee7d21/etsy-2.jpg","https://media.gemworkers.com/items/27760205-aaa0-4345-8652-e344baee7d21/etsy-3.jpg","https://media.gemworkers.com/items/27760205-aaa0-4345-8652-e344baee7d21/etsy-4.jpg","https://media.gemworkers.com/items/27760205-aaa0-4345-8652-e344baee7d21/etsy-5.jpg","https://media.gemworkers.com/items/27760205-aaa0-4345-8652-e344baee7d21/etsy-6.jpg","https://media.gemworkers.com/items/27760205-aaa0-4345-8652-e344baee7d21/etsy-7.jpg","https://media.gemworkers.com/items/27760205-aaa0-4345-8652-e344baee7d21/etsy-8.jpg","https://media.gemworkers.com/items/27760205-aaa0-4345-8652-e344baee7d21/etsy-9.jpg","https://media.gemworkers.com/items/27760205-aaa0-4345-8652-e344baee7d21/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 600 USD, converted at ECB rate. Etsy tags: Jewellery Supplies,Gift For Her,Natural Stone,Silver Sterling,Gold Ring,Tourmaline Jewellery,y2k earrings stud,Seafoam Tourmaline,Mint Tourmaline,Blue Tourmaline,Jewels,lagoon tourmaline,Oceangemsminerals.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('48f50651-bcb3-4a45-9ca8-b3bd82644596', '4.55 Cts Chrome Green Tourmaline', 'Gorgeous Mesmerising Chrome Green Cool Colour Afghan Tourmaline 

One Of A Kind

4.55 Cts 
11.4x6.8x5.5mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 356, 1, 'loose_stone', 'Tourmaline', NULL, 4.55, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/48f50651-bcb3-4a45-9ca8-b3bd82644596/etsy-1.jpg","https://media.gemworkers.com/items/48f50651-bcb3-4a45-9ca8-b3bd82644596/etsy-2.jpg","https://media.gemworkers.com/items/48f50651-bcb3-4a45-9ca8-b3bd82644596/etsy-3.jpg","https://media.gemworkers.com/items/48f50651-bcb3-4a45-9ca8-b3bd82644596/etsy-4.jpg","https://media.gemworkers.com/items/48f50651-bcb3-4a45-9ca8-b3bd82644596/etsy-5.jpg","https://media.gemworkers.com/items/48f50651-bcb3-4a45-9ca8-b3bd82644596/etsy-6.jpg","https://media.gemworkers.com/items/48f50651-bcb3-4a45-9ca8-b3bd82644596/etsy-7.jpg","https://media.gemworkers.com/items/48f50651-bcb3-4a45-9ca8-b3bd82644596/etsy-8.jpg","https://media.gemworkers.com/items/48f50651-bcb3-4a45-9ca8-b3bd82644596/etsy-9.jpg","https://media.gemworkers.com/items/48f50651-bcb3-4a45-9ca8-b3bd82644596/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 399 USD, converted at ECB rate. Etsy tags: Tourmaline Jewellery,Jewellery Supplies,Jewellery Making,Jewellery Findings,Tourmaline Earrings,Earrings Stud,y2k earrings stud,Gold Rings,Natural Stone,Gift For Her,Rings For Men,Rings For Women,Chrome Tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('bd4a5132-8d4d-4527-8d58-0e5d9a23750a', '4 Cts Blue bicolour tourmalines', 'Unique Blue Bicolour Tourmaline 

4 Cts
15.2 x 4.7 x 3.6mm
10.2 x 3.9 x 3.3mm

no treatment.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 357, 1, 'loose_stone', 'Tourmaline', NULL, 4, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/bd4a5132-8d4d-4527-8d58-0e5d9a23750a/etsy-1.jpg","https://media.gemworkers.com/items/bd4a5132-8d4d-4527-8d58-0e5d9a23750a/etsy-2.jpg","https://media.gemworkers.com/items/bd4a5132-8d4d-4527-8d58-0e5d9a23750a/etsy-3.jpg","https://media.gemworkers.com/items/bd4a5132-8d4d-4527-8d58-0e5d9a23750a/etsy-4.jpg","https://media.gemworkers.com/items/bd4a5132-8d4d-4527-8d58-0e5d9a23750a/etsy-5.jpg","https://media.gemworkers.com/items/bd4a5132-8d4d-4527-8d58-0e5d9a23750a/etsy-6.jpg","https://media.gemworkers.com/items/bd4a5132-8d4d-4527-8d58-0e5d9a23750a/etsy-7.jpg","https://media.gemworkers.com/items/bd4a5132-8d4d-4527-8d58-0e5d9a23750a/etsy-8.jpg","https://media.gemworkers.com/items/bd4a5132-8d4d-4527-8d58-0e5d9a23750a/etsy-9.jpg","https://media.gemworkers.com/items/bd4a5132-8d4d-4527-8d58-0e5d9a23750a/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 400 USD, converted at ECB rate. Etsy tags: Blue Bicolour,Bicolour Tourmaline,Blue Tourmaline,Lavender Tourmaline,Purple Tourmaline,Lagoon tourmaline,neon blue tourmaline,jewellery making,jewellery findings,jewellery supplies,gift for her,Natural stone,Handmadejewellery.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('30a0e57d-054b-48ae-a63b-21e5d4c3ffb9', '5.50 Cts Paraiba Colour Tourmaline Cabochon', 'Gorgeous High Lustre Cabochon Paraiba Colour Tourmaline 

High Quality Cabochon

Rare And One Of A Kind

5.50 Cts
9.9 x 9.6 x 7.3mm

unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 223, 1, 'loose_stone', 'Tourmaline', 'Paraiba', 5.5, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/30a0e57d-054b-48ae-a63b-21e5d4c3ffb9/etsy-1.jpg","https://media.gemworkers.com/items/30a0e57d-054b-48ae-a63b-21e5d4c3ffb9/etsy-2.jpg","https://media.gemworkers.com/items/30a0e57d-054b-48ae-a63b-21e5d4c3ffb9/etsy-3.jpg","https://media.gemworkers.com/items/30a0e57d-054b-48ae-a63b-21e5d4c3ffb9/etsy-4.jpg","https://media.gemworkers.com/items/30a0e57d-054b-48ae-a63b-21e5d4c3ffb9/etsy-5.jpg","https://media.gemworkers.com/items/30a0e57d-054b-48ae-a63b-21e5d4c3ffb9/etsy-6.jpg","https://media.gemworkers.com/items/30a0e57d-054b-48ae-a63b-21e5d4c3ffb9/etsy-7.jpg","https://media.gemworkers.com/items/30a0e57d-054b-48ae-a63b-21e5d4c3ffb9/etsy-8.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 250 USD, converted at ECB rate. Etsy tags: Gold Rings,Rings For Men,Tourmaline Jewellery,Natural Stone,bicolour Tourmaline,Lagoon tourmaline,Bluegreen tourmaline,blue tourmaline,tourmaline rings,faceted tourmaline,Oceangemsminerals,Paraiba Tourmaline,Paraiba Cabochon.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('33a6150d-feb9-4ba1-870b-7916d6605725', '4.85 Cts Paraiba Colour Tourmaline Cabochon', 'Gorgeous High Lustre Cabochon Paraiba Colour Tourmaline 

High Quality Cabochon

Rare And One Of A Kind

4.85 Cts
9.9 x 9.9 x 6.2mm

unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 216, 1, 'loose_stone', 'Tourmaline', 'Paraiba', 4.85, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/33a6150d-feb9-4ba1-870b-7916d6605725/etsy-1.jpg","https://media.gemworkers.com/items/33a6150d-feb9-4ba1-870b-7916d6605725/etsy-2.jpg","https://media.gemworkers.com/items/33a6150d-feb9-4ba1-870b-7916d6605725/etsy-3.jpg","https://media.gemworkers.com/items/33a6150d-feb9-4ba1-870b-7916d6605725/etsy-4.jpg","https://media.gemworkers.com/items/33a6150d-feb9-4ba1-870b-7916d6605725/etsy-5.jpg","https://media.gemworkers.com/items/33a6150d-feb9-4ba1-870b-7916d6605725/etsy-6.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 242 USD, converted at ECB rate. Etsy tags: Gold Rings,Rings For Men,Tourmaline Jewellery,Natural Stone,bicolour Tourmaline,Lagoon tourmaline,Bluegreen tourmaline,blue tourmaline,tourmaline rings,faceted tourmaline,Oceangemsminerals,Paraiba Tourmaline,Paraiba Cabochon.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('88e29e13-bb43-4832-ae42-37c44eb48463', '4.45 Cts Vibrant Indicolite tourmaline', 'Unique Vibrant Indicolite Tourmalines

high lustre 

4.45 Cts 

Size: 4.9x4.2x3.7mm to 10.1x4x3.2mm

no treatment.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 393, 1, 'loose_stone', 'Tourmaline', 'Indicolite', 4.45, 'ct', NULL, NULL, '4.9x4.2x3.7', '["https://media.gemworkers.com/items/88e29e13-bb43-4832-ae42-37c44eb48463/etsy-1.jpg","https://media.gemworkers.com/items/88e29e13-bb43-4832-ae42-37c44eb48463/etsy-2.jpg","https://media.gemworkers.com/items/88e29e13-bb43-4832-ae42-37c44eb48463/etsy-3.jpg","https://media.gemworkers.com/items/88e29e13-bb43-4832-ae42-37c44eb48463/etsy-4.jpg","https://media.gemworkers.com/items/88e29e13-bb43-4832-ae42-37c44eb48463/etsy-5.jpg","https://media.gemworkers.com/items/88e29e13-bb43-4832-ae42-37c44eb48463/etsy-6.jpg","https://media.gemworkers.com/items/88e29e13-bb43-4832-ae42-37c44eb48463/etsy-7.jpg","https://media.gemworkers.com/items/88e29e13-bb43-4832-ae42-37c44eb48463/etsy-8.jpg","https://media.gemworkers.com/items/88e29e13-bb43-4832-ae42-37c44eb48463/etsy-9.jpg","https://media.gemworkers.com/items/88e29e13-bb43-4832-ae42-37c44eb48463/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 440 USD, converted at ECB rate. Etsy tags: Blue Bicolour,Bicolour Tourmaline,Blue Tourmaline,Lavender Tourmaline,Purple Tourmaline,Lagoon tourmaline,neon blue tourmaline,jewellery making,gift for her,Natural stone,Handmadejewellery,Seafoam Tourmaline,Unique Tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('bc2f1903-9b62-4410-85c9-24adef451250', '4.4 Cts Vibrant Green Tourmaline pair', 'Beautiful Top Green Afghan Tourmaline

Vibrant Colour

Reverse Pair 

4.40 Cts 
Size:10x5.6x4.5mm

Unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 348, 1, 'loose_stone', 'Tourmaline', NULL, 4.4, 'ct', 'Afghanistan', NULL, '10x5.6x4.5', '["https://media.gemworkers.com/items/bc2f1903-9b62-4410-85c9-24adef451250/etsy-1.jpg","https://media.gemworkers.com/items/bc2f1903-9b62-4410-85c9-24adef451250/etsy-2.jpg","https://media.gemworkers.com/items/bc2f1903-9b62-4410-85c9-24adef451250/etsy-3.jpg","https://media.gemworkers.com/items/bc2f1903-9b62-4410-85c9-24adef451250/etsy-4.jpg","https://media.gemworkers.com/items/bc2f1903-9b62-4410-85c9-24adef451250/etsy-5.jpg","https://media.gemworkers.com/items/bc2f1903-9b62-4410-85c9-24adef451250/etsy-6.jpg","https://media.gemworkers.com/items/bc2f1903-9b62-4410-85c9-24adef451250/etsy-7.jpg","https://media.gemworkers.com/items/bc2f1903-9b62-4410-85c9-24adef451250/etsy-8.jpg","https://media.gemworkers.com/items/bc2f1903-9b62-4410-85c9-24adef451250/etsy-9.jpg","https://media.gemworkers.com/items/bc2f1903-9b62-4410-85c9-24adef451250/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 390 USD, converted at ECB rate. Etsy tags: Green Tourmaline,Vibrant Tourmaline,AppleGreenTourmaline,Tourmaline jewellery,jewellers,jewellery making,jewellery supplies,jewellery findings,Oceangemsminerals,rings for women,rings for men,rings jewellery,natural stone.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('912a6326-9fa0-4d7c-a451-c0e252ce325e', '2 Cts Paraiba Colour Tourmaline Cabochon', 'Gorgeous High Lustre Cabochon Paraiba Colour Tourmaline 

2 Cts
7.6 x 7.4 x 4.6mm

unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 89, 1, 'loose_stone', 'Tourmaline', 'Paraiba', 2, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/912a6326-9fa0-4d7c-a451-c0e252ce325e/etsy-1.jpg","https://media.gemworkers.com/items/912a6326-9fa0-4d7c-a451-c0e252ce325e/etsy-2.jpg","https://media.gemworkers.com/items/912a6326-9fa0-4d7c-a451-c0e252ce325e/etsy-3.jpg","https://media.gemworkers.com/items/912a6326-9fa0-4d7c-a451-c0e252ce325e/etsy-4.jpg","https://media.gemworkers.com/items/912a6326-9fa0-4d7c-a451-c0e252ce325e/etsy-5.jpg","https://media.gemworkers.com/items/912a6326-9fa0-4d7c-a451-c0e252ce325e/etsy-6.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 100 USD, converted at ECB rate. Etsy tags: Gold Rings,Rings For Men,Tourmaline Jewellery,Natural Stone,bicolour Tourmaline,Lagoon tourmaline,Bluegreen tourmaline,blue tourmaline,indicolite tourmalin,tourmaline rings,faceted tourmaline,Oceangemsminerals,tourmaline lot.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('7913bbd7-782c-48ca-ace3-5d99743221d2', 'Aquamarine Specimen 1.4 KG', 'A Truly Tremendous Piece Of Nature 

Aquamarine From Shigar Mine 100% natural 

Damage Free and Four Terminated Crystals In It , a one of a kind and collection piece for sure

1.4 kg
165 x 114 x 53 mm

No treatment whatsoever.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 1295, 1, 'specimen', 'Aquamarine', NULL, NULL, NULL, NULL, NULL, NULL, '["https://media.gemworkers.com/items/7913bbd7-782c-48ca-ace3-5d99743221d2/etsy-1.jpg","https://media.gemworkers.com/items/7913bbd7-782c-48ca-ace3-5d99743221d2/etsy-2.jpg","https://media.gemworkers.com/items/7913bbd7-782c-48ca-ace3-5d99743221d2/etsy-3.jpg","https://media.gemworkers.com/items/7913bbd7-782c-48ca-ace3-5d99743221d2/etsy-4.jpg","https://media.gemworkers.com/items/7913bbd7-782c-48ca-ace3-5d99743221d2/etsy-5.jpg","https://media.gemworkers.com/items/7913bbd7-782c-48ca-ace3-5d99743221d2/etsy-6.jpg","https://media.gemworkers.com/items/7913bbd7-782c-48ca-ace3-5d99743221d2/etsy-7.jpg","https://media.gemworkers.com/items/7913bbd7-782c-48ca-ace3-5d99743221d2/etsy-8.jpg","https://media.gemworkers.com/items/7913bbd7-782c-48ca-ace3-5d99743221d2/etsy-9.jpg","https://media.gemworkers.com/items/7913bbd7-782c-48ca-ace3-5d99743221d2/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 1450 USD, converted at ECB rate. Etsy tags: Aquamarine Specimen,Aquamarine Museum,Aquamarine Crystal,Blue Aquamarine,Rare Aquamarine,Multi Crystal,Specimen Crystals,Aquamarine Jewellery,Collectors,Jewels,Oceangemsminerals,Lagoon Tourmaline,Blue Tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('aa30e994-ed21-459d-9fa0-f77a96680e96', '1.4 Cts Indigo blue Tourmaline', 'indigo blue colour tourmaline 

mesmerising rare colour, cute looking tourmaline.

1.40 Cts
6 x 5.6 x 4.8mm

no treatment whatsoever.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 268, 1, 'loose_stone', 'Tourmaline', NULL, 1.4, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/aa30e994-ed21-459d-9fa0-f77a96680e96/etsy-1.jpg","https://media.gemworkers.com/items/aa30e994-ed21-459d-9fa0-f77a96680e96/etsy-2.jpg","https://media.gemworkers.com/items/aa30e994-ed21-459d-9fa0-f77a96680e96/etsy-3.jpg","https://media.gemworkers.com/items/aa30e994-ed21-459d-9fa0-f77a96680e96/etsy-4.jpg","https://media.gemworkers.com/items/aa30e994-ed21-459d-9fa0-f77a96680e96/etsy-5.jpg","https://media.gemworkers.com/items/aa30e994-ed21-459d-9fa0-f77a96680e96/etsy-6.jpg","https://media.gemworkers.com/items/aa30e994-ed21-459d-9fa0-f77a96680e96/etsy-7.jpg","https://media.gemworkers.com/items/aa30e994-ed21-459d-9fa0-f77a96680e96/etsy-8.jpg","https://media.gemworkers.com/items/aa30e994-ed21-459d-9fa0-f77a96680e96/etsy-9.jpg","https://media.gemworkers.com/items/aa30e994-ed21-459d-9fa0-f77a96680e96/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 300 USD, converted at ECB rate. Etsy tags: Tourmaline Jewellery,Tourmaline Rings,Blue Tourmaline,Gift For Her,Rings For Women,Rings For Men,Gold Rings,Natural Stone,lagoon tourmaline,indigo tourmaline,indicolitetourmaline,Oceangemsminerals,ink blue tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('ba7e60ae-a139-45bf-a1ad-4f19ed666ba6', '1.7 Cts Ice Blue Tourmaline', 'Ice Blue Tourmaline 

Bright And Lustre

1.70 Cts 
Size:7.2x6.5x4.8mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 268, 1, 'loose_stone', 'Tourmaline', NULL, 1.7, 'ct', NULL, NULL, '7.2x6.5x4.8', '["https://media.gemworkers.com/items/ba7e60ae-a139-45bf-a1ad-4f19ed666ba6/etsy-1.jpg","https://media.gemworkers.com/items/ba7e60ae-a139-45bf-a1ad-4f19ed666ba6/etsy-2.jpg","https://media.gemworkers.com/items/ba7e60ae-a139-45bf-a1ad-4f19ed666ba6/etsy-3.jpg","https://media.gemworkers.com/items/ba7e60ae-a139-45bf-a1ad-4f19ed666ba6/etsy-4.jpg","https://media.gemworkers.com/items/ba7e60ae-a139-45bf-a1ad-4f19ed666ba6/etsy-5.jpg","https://media.gemworkers.com/items/ba7e60ae-a139-45bf-a1ad-4f19ed666ba6/etsy-6.jpg","https://media.gemworkers.com/items/ba7e60ae-a139-45bf-a1ad-4f19ed666ba6/etsy-7.jpg","https://media.gemworkers.com/items/ba7e60ae-a139-45bf-a1ad-4f19ed666ba6/etsy-8.jpg","https://media.gemworkers.com/items/ba7e60ae-a139-45bf-a1ad-4f19ed666ba6/etsy-9.jpg","https://media.gemworkers.com/items/ba7e60ae-a139-45bf-a1ad-4f19ed666ba6/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 300 USD, converted at ECB rate. Etsy tags: Paraiba Tourmaline,Paraiba Colour,Lagoon Tourmaline,Bluegreen Tourmaline,Blue Tourmaline,Neon Blue Tourmaline,Tourmaline Jewellery,Jewellers,Lagoon Colour,Oceangemsminerals,Ink Blue Tourmaline,Wedding Rings,Rings For Women.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('f4b67ba2-9726-40b9-b505-64dab5af2e22', '1.4 Cts Lagoon Green Tourmaline', 'Gorgeous Mesmerising Blue Green Afghan Tourmaline 

Unique Colour 

1.4 Cts
7 x 5.3 x 4.4mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 250, 1, 'loose_stone', 'Tourmaline', NULL, 1.4, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/f4b67ba2-9726-40b9-b505-64dab5af2e22/etsy-1.jpg","https://media.gemworkers.com/items/f4b67ba2-9726-40b9-b505-64dab5af2e22/etsy-2.jpg","https://media.gemworkers.com/items/f4b67ba2-9726-40b9-b505-64dab5af2e22/etsy-3.jpg","https://media.gemworkers.com/items/f4b67ba2-9726-40b9-b505-64dab5af2e22/etsy-4.jpg","https://media.gemworkers.com/items/f4b67ba2-9726-40b9-b505-64dab5af2e22/etsy-5.jpg","https://media.gemworkers.com/items/f4b67ba2-9726-40b9-b505-64dab5af2e22/etsy-6.jpg","https://media.gemworkers.com/items/f4b67ba2-9726-40b9-b505-64dab5af2e22/etsy-7.jpg","https://media.gemworkers.com/items/f4b67ba2-9726-40b9-b505-64dab5af2e22/etsy-8.jpg","https://media.gemworkers.com/items/f4b67ba2-9726-40b9-b505-64dab5af2e22/etsy-9.jpg","https://media.gemworkers.com/items/f4b67ba2-9726-40b9-b505-64dab5af2e22/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 280 USD, converted at ECB rate. Etsy tags: BlueGreen Tourmaline,Blue Tourmaline,Green Tourmaline,Lagoon Tourmaline,Neon Tourmaline,Tourmaline Rings,rings for women,rings for men,jewellery making,jewellery supplies,jewellery findings,gift for her,natural stone.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('84b7499d-b29d-48dd-951c-aa30efeae128', '1.9 Cts Seafoam Blue Tourmaline', 'Seafoam Blue Tourmaline

high lustre and brilliance, Excellent Cut and polish.

1.90 Cts
7x6.4x5.6mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 232, 1, 'loose_stone', 'Tourmaline', NULL, 1.9, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/84b7499d-b29d-48dd-951c-aa30efeae128/etsy-1.jpg","https://media.gemworkers.com/items/84b7499d-b29d-48dd-951c-aa30efeae128/etsy-2.jpg","https://media.gemworkers.com/items/84b7499d-b29d-48dd-951c-aa30efeae128/etsy-3.jpg","https://media.gemworkers.com/items/84b7499d-b29d-48dd-951c-aa30efeae128/etsy-4.jpg","https://media.gemworkers.com/items/84b7499d-b29d-48dd-951c-aa30efeae128/etsy-5.jpg","https://media.gemworkers.com/items/84b7499d-b29d-48dd-951c-aa30efeae128/etsy-6.jpg","https://media.gemworkers.com/items/84b7499d-b29d-48dd-951c-aa30efeae128/etsy-7.jpg","https://media.gemworkers.com/items/84b7499d-b29d-48dd-951c-aa30efeae128/etsy-8.jpg","https://media.gemworkers.com/items/84b7499d-b29d-48dd-951c-aa30efeae128/etsy-9.jpg","https://media.gemworkers.com/items/84b7499d-b29d-48dd-951c-aa30efeae128/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 260 USD, converted at ECB rate. Etsy tags: Seafoam Tourmaline,Loose Gemstones,Jewellery making,jewellery supplies,jewellery findings,gift for her,natural stone,Handmadejewellery,jewels,Tourmaline Jewellery,Tourmaline Lots,Blue Tourmaline,Neon Tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('38a21ce9-0121-4ee9-b256-e4acdfac5428', '3 Cts Vibrant Green Tourmaline pair', 'Beautiful Top Green Afghan Tourmaline

Vibrant Colour

Not A Perfect Pair But Can Be Used As A Pair

3 Cts 
6.5x6.1x4.8mm 
6.6x6x5.1mm

Unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 491, 1, 'loose_stone', 'Tourmaline', NULL, 3, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/38a21ce9-0121-4ee9-b256-e4acdfac5428/etsy-1.jpg","https://media.gemworkers.com/items/38a21ce9-0121-4ee9-b256-e4acdfac5428/etsy-2.jpg","https://media.gemworkers.com/items/38a21ce9-0121-4ee9-b256-e4acdfac5428/etsy-3.jpg","https://media.gemworkers.com/items/38a21ce9-0121-4ee9-b256-e4acdfac5428/etsy-4.jpg","https://media.gemworkers.com/items/38a21ce9-0121-4ee9-b256-e4acdfac5428/etsy-5.jpg","https://media.gemworkers.com/items/38a21ce9-0121-4ee9-b256-e4acdfac5428/etsy-6.jpg","https://media.gemworkers.com/items/38a21ce9-0121-4ee9-b256-e4acdfac5428/etsy-7.jpg","https://media.gemworkers.com/items/38a21ce9-0121-4ee9-b256-e4acdfac5428/etsy-8.jpg","https://media.gemworkers.com/items/38a21ce9-0121-4ee9-b256-e4acdfac5428/etsy-9.jpg","https://media.gemworkers.com/items/38a21ce9-0121-4ee9-b256-e4acdfac5428/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 550 USD, converted at ECB rate. Etsy tags: Green Tourmaline,Vibrant Tourmaline,AppleGreenTourmaline,Tourmaline jewellery,jewellers,jewellery making,jewellery supplies,jewellery findings,Oceangemsminerals,rings for women,rings for men,rings jewellery,natural stone.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('6e9936aa-3c52-4aeb-aa8e-8250667e237a', '3 Cts Vibrant Green Tourmaline', 'Beautiful Top Green Afghan Tourmaline

Vibrant Colour

Perfectly Cut

3 Cts
7.6 x 7.5 x 6.5mm

Unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 491, 1, 'loose_stone', 'Tourmaline', NULL, 3, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/6e9936aa-3c52-4aeb-aa8e-8250667e237a/etsy-1.jpg","https://media.gemworkers.com/items/6e9936aa-3c52-4aeb-aa8e-8250667e237a/etsy-2.jpg","https://media.gemworkers.com/items/6e9936aa-3c52-4aeb-aa8e-8250667e237a/etsy-3.jpg","https://media.gemworkers.com/items/6e9936aa-3c52-4aeb-aa8e-8250667e237a/etsy-4.jpg","https://media.gemworkers.com/items/6e9936aa-3c52-4aeb-aa8e-8250667e237a/etsy-5.jpg","https://media.gemworkers.com/items/6e9936aa-3c52-4aeb-aa8e-8250667e237a/etsy-6.jpg","https://media.gemworkers.com/items/6e9936aa-3c52-4aeb-aa8e-8250667e237a/etsy-7.jpg","https://media.gemworkers.com/items/6e9936aa-3c52-4aeb-aa8e-8250667e237a/etsy-8.jpg","https://media.gemworkers.com/items/6e9936aa-3c52-4aeb-aa8e-8250667e237a/etsy-9.jpg","https://media.gemworkers.com/items/6e9936aa-3c52-4aeb-aa8e-8250667e237a/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 550 USD, converted at ECB rate. Etsy tags: Green Tourmaline,Vibrant Tourmaline,AppleGreenTourmaline,Tourmaline jewellery,jewellers,jewellery making,jewellery supplies,jewellery findings,Oceangemsminerals,rings for women,rings for men,rings jewellery,natural stone.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('0fde64d3-50e2-4834-b9d8-0499fec24ae0', '1.80 Cts Ink Blue Tourmaline', 'Top Ink Blue and biColour Tourmaline Emerald Cut 

rare find

1.80 Cts
6.4 x 4.4 x 3.2mm
5.4 x 4 x 3.1mm

No Treatment Whatsoever.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 89, 1, 'loose_stone', 'Tourmaline', NULL, 1.8, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/0fde64d3-50e2-4834-b9d8-0499fec24ae0/etsy-1.jpg","https://media.gemworkers.com/items/0fde64d3-50e2-4834-b9d8-0499fec24ae0/etsy-2.jpg","https://media.gemworkers.com/items/0fde64d3-50e2-4834-b9d8-0499fec24ae0/etsy-3.jpg","https://media.gemworkers.com/items/0fde64d3-50e2-4834-b9d8-0499fec24ae0/etsy-4.jpg","https://media.gemworkers.com/items/0fde64d3-50e2-4834-b9d8-0499fec24ae0/etsy-5.jpg","https://media.gemworkers.com/items/0fde64d3-50e2-4834-b9d8-0499fec24ae0/etsy-6.jpg","https://media.gemworkers.com/items/0fde64d3-50e2-4834-b9d8-0499fec24ae0/etsy-7.jpg","https://media.gemworkers.com/items/0fde64d3-50e2-4834-b9d8-0499fec24ae0/etsy-8.jpg","https://media.gemworkers.com/items/0fde64d3-50e2-4834-b9d8-0499fec24ae0/etsy-9.jpg","https://media.gemworkers.com/items/0fde64d3-50e2-4834-b9d8-0499fec24ae0/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 100 USD, converted at ECB rate. Etsy tags: Emerald Cut,EmeraldCutTourmaline,Jewellery making,earrings stud,Tourmaline Lot,Blue Tourmaline,Lagoon Tourmaline,Neon Blue,neon blue tourmaline,Rings For Men,Tourmalines,Ink Blue Tourmaline,Oceangemsminerals.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('3f451064-8079-4b7d-b758-9323adf40120', '5.70 Cts Neon Blue Bicolour Tourmaline', 'Top Quality Neon Blue Bicolour Tourmaline Emerald Cut and Buguet Cut

jewellery size, rare find 

5.70 Cts
8.7 to 2.9mm

No Treatment Whatsoever.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 313, 1, 'loose_stone', 'Tourmaline', NULL, 5.7, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/3f451064-8079-4b7d-b758-9323adf40120/etsy-1.jpg","https://media.gemworkers.com/items/3f451064-8079-4b7d-b758-9323adf40120/etsy-2.jpg","https://media.gemworkers.com/items/3f451064-8079-4b7d-b758-9323adf40120/etsy-3.jpg","https://media.gemworkers.com/items/3f451064-8079-4b7d-b758-9323adf40120/etsy-4.jpg","https://media.gemworkers.com/items/3f451064-8079-4b7d-b758-9323adf40120/etsy-5.jpg","https://media.gemworkers.com/items/3f451064-8079-4b7d-b758-9323adf40120/etsy-6.jpg","https://media.gemworkers.com/items/3f451064-8079-4b7d-b758-9323adf40120/etsy-7.jpg","https://media.gemworkers.com/items/3f451064-8079-4b7d-b758-9323adf40120/etsy-8.jpg","https://media.gemworkers.com/items/3f451064-8079-4b7d-b758-9323adf40120/etsy-9.jpg","https://media.gemworkers.com/items/3f451064-8079-4b7d-b758-9323adf40120/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 350 USD, converted at ECB rate. Etsy tags: Emerald Cut,EmeraldCutTourmaline,Jewellery making,earrings stud,Tourmaline Lot,Blue Tourmaline,Lagoon Tourmaline,Neon Blue,neon blue tourmaline,Rings For Men,Tourmalines,Ink Blue Tourmaline,Oceangemsminerals.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('5a83ef26-5809-4674-98e0-81634bebd01c', '7.3 Cts Seafoam Blue Green Tourmaline Lot', 'Mesmerising Seafoam Blue Green Tourmaline Lot

7.3 Cts
11.5 to 4.5mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 179, 1, 'loose_stone', 'Tourmaline', NULL, 7.3, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/5a83ef26-5809-4674-98e0-81634bebd01c/etsy-1.jpg","https://media.gemworkers.com/items/5a83ef26-5809-4674-98e0-81634bebd01c/etsy-2.jpg","https://media.gemworkers.com/items/5a83ef26-5809-4674-98e0-81634bebd01c/etsy-3.jpg","https://media.gemworkers.com/items/5a83ef26-5809-4674-98e0-81634bebd01c/etsy-4.jpg","https://media.gemworkers.com/items/5a83ef26-5809-4674-98e0-81634bebd01c/etsy-5.jpg","https://media.gemworkers.com/items/5a83ef26-5809-4674-98e0-81634bebd01c/etsy-6.jpg","https://media.gemworkers.com/items/5a83ef26-5809-4674-98e0-81634bebd01c/etsy-7.jpg","https://media.gemworkers.com/items/5a83ef26-5809-4674-98e0-81634bebd01c/etsy-8.jpg","https://media.gemworkers.com/items/5a83ef26-5809-4674-98e0-81634bebd01c/etsy-9.jpg","https://media.gemworkers.com/items/5a83ef26-5809-4674-98e0-81634bebd01c/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 200 USD, converted at ECB rate. Etsy tags: Seafoam Tourmaline,Emerald Cut,Tourmaline Lot,Green Tourmaline,Loose Gemstones,Jewellery Making,Jewellery Supplies,jewellery findings,natural stone,jewels,Handmadejewellery,Lagoon Tourmaline,Jewellery.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('4a4cb4a8-a90c-4f7a-97a1-f63a8c3e6ddc', '1.40 Cts Hexagon Tourmaline Pair', 'Gorgeous Long Hexagon Cut Tourmaline Pair

High Lustre And brilliance 

1.40 Cts
14.7 x 2.8 x 2.2mm

100% Natural No treatment whatsoever', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 134, 1, 'loose_stone', 'Tourmaline', NULL, 1.4, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/4a4cb4a8-a90c-4f7a-97a1-f63a8c3e6ddc/etsy-1.jpg","https://media.gemworkers.com/items/4a4cb4a8-a90c-4f7a-97a1-f63a8c3e6ddc/etsy-2.jpg","https://media.gemworkers.com/items/4a4cb4a8-a90c-4f7a-97a1-f63a8c3e6ddc/etsy-3.jpg","https://media.gemworkers.com/items/4a4cb4a8-a90c-4f7a-97a1-f63a8c3e6ddc/etsy-4.jpg","https://media.gemworkers.com/items/4a4cb4a8-a90c-4f7a-97a1-f63a8c3e6ddc/etsy-5.jpg","https://media.gemworkers.com/items/4a4cb4a8-a90c-4f7a-97a1-f63a8c3e6ddc/etsy-6.jpg","https://media.gemworkers.com/items/4a4cb4a8-a90c-4f7a-97a1-f63a8c3e6ddc/etsy-7.jpg","https://media.gemworkers.com/items/4a4cb4a8-a90c-4f7a-97a1-f63a8c3e6ddc/etsy-8.jpg","https://media.gemworkers.com/items/4a4cb4a8-a90c-4f7a-97a1-f63a8c3e6ddc/etsy-9.jpg","https://media.gemworkers.com/items/4a4cb4a8-a90c-4f7a-97a1-f63a8c3e6ddc/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 150 USD, converted at ECB rate. Etsy tags: Tourmaline Earrings,Jewellery Making,Jewellery Findings,y2k earrings stud,Earrings findings,emerald cut,bicolour tourmaline,Tourmaline Pairs,gift for her,Natural Stone,blue tourmaline lot,Oceangemsminerals,Clean Tourmaline. Had variations on Etsy — check size/options.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('add3f4fd-63e5-48ff-b9ce-a0a4836ce21f', '4 Cts Vibrant Tourmaline Gemstone: Unheated, Untreated', 'Top Quality Bicolour Tourmaline 

Best and vibrant colour 

4 Cts
16.7 x 5.4 x 4.6mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 714, 1, 'loose_stone', 'Tourmaline', NULL, 4, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/add3f4fd-63e5-48ff-b9ce-a0a4836ce21f/etsy-1.jpg","https://media.gemworkers.com/items/add3f4fd-63e5-48ff-b9ce-a0a4836ce21f/etsy-2.jpg","https://media.gemworkers.com/items/add3f4fd-63e5-48ff-b9ce-a0a4836ce21f/etsy-3.jpg","https://media.gemworkers.com/items/add3f4fd-63e5-48ff-b9ce-a0a4836ce21f/etsy-4.jpg","https://media.gemworkers.com/items/add3f4fd-63e5-48ff-b9ce-a0a4836ce21f/etsy-5.jpg","https://media.gemworkers.com/items/add3f4fd-63e5-48ff-b9ce-a0a4836ce21f/etsy-6.jpg","https://media.gemworkers.com/items/add3f4fd-63e5-48ff-b9ce-a0a4836ce21f/etsy-7.jpg","https://media.gemworkers.com/items/add3f4fd-63e5-48ff-b9ce-a0a4836ce21f/etsy-8.jpg","https://media.gemworkers.com/items/add3f4fd-63e5-48ff-b9ce-a0a4836ce21f/etsy-9.jpg","https://media.gemworkers.com/items/add3f4fd-63e5-48ff-b9ce-a0a4836ce21f/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 799 USD, converted at ECB rate. Etsy tags: Tourmaline Lot,Tourmaline Jewellery,Bluegreen Tourmaline,Lagoon Tourmaline,Blue Tourmaline,Green Tourmaline,Seafoam Tourmaline,Bicolour Tourmaline,Oceangemsminerals,Mint Tourmaline,Vivid Tourmaline Lot,Tourmaline Supplies,Jewellers.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('fd1acc17-d1ce-42ae-b170-5b18eece6241', '2.25 Cts, Lagoon Tourmaline', 'Gorgeous Mesmerising Lagoon Tourmaline 

More beautiful In real, One of a kind

2.25 Cts
8.8 x 6.3 x 4.9mm

unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 201, 1, 'loose_stone', 'Tourmaline', NULL, 2.25, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/fd1acc17-d1ce-42ae-b170-5b18eece6241/etsy-1.jpg","https://media.gemworkers.com/items/fd1acc17-d1ce-42ae-b170-5b18eece6241/etsy-2.jpg","https://media.gemworkers.com/items/fd1acc17-d1ce-42ae-b170-5b18eece6241/etsy-3.jpg","https://media.gemworkers.com/items/fd1acc17-d1ce-42ae-b170-5b18eece6241/etsy-4.jpg","https://media.gemworkers.com/items/fd1acc17-d1ce-42ae-b170-5b18eece6241/etsy-5.jpg","https://media.gemworkers.com/items/fd1acc17-d1ce-42ae-b170-5b18eece6241/etsy-6.jpg","https://media.gemworkers.com/items/fd1acc17-d1ce-42ae-b170-5b18eece6241/etsy-7.jpg","https://media.gemworkers.com/items/fd1acc17-d1ce-42ae-b170-5b18eece6241/etsy-8.jpg","https://media.gemworkers.com/items/fd1acc17-d1ce-42ae-b170-5b18eece6241/etsy-9.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 225 USD, converted at ECB rate. Etsy tags: Jewellery Supplies,Jewellery Making,Gold Rings,Rings For Men,Rings For Women,y2k earrings stud,Gift For Her,Tourmaline Jewellery,Natural Stone,Stud Earrings,Jewellery Stud,bicolour Tourmaline,Lagoon tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('6a9f8cea-4477-43c4-8f98-38e00bf38dd8', '3.50 Cts Green Tourmaline', 'Beautiful green tourmaline 

Inclusion give it special characteristics 

Looks Better In Real

3.50 Cts
8.8 x 7.5 x 6mm

Unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 116, 1, 'loose_stone', 'Tourmaline', NULL, 3.5, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/6a9f8cea-4477-43c4-8f98-38e00bf38dd8/etsy-1.jpg","https://media.gemworkers.com/items/6a9f8cea-4477-43c4-8f98-38e00bf38dd8/etsy-2.jpg","https://media.gemworkers.com/items/6a9f8cea-4477-43c4-8f98-38e00bf38dd8/etsy-3.jpg","https://media.gemworkers.com/items/6a9f8cea-4477-43c4-8f98-38e00bf38dd8/etsy-4.jpg","https://media.gemworkers.com/items/6a9f8cea-4477-43c4-8f98-38e00bf38dd8/etsy-5.jpg","https://media.gemworkers.com/items/6a9f8cea-4477-43c4-8f98-38e00bf38dd8/etsy-6.jpg","https://media.gemworkers.com/items/6a9f8cea-4477-43c4-8f98-38e00bf38dd8/etsy-7.jpg","https://media.gemworkers.com/items/6a9f8cea-4477-43c4-8f98-38e00bf38dd8/etsy-8.jpg","https://media.gemworkers.com/items/6a9f8cea-4477-43c4-8f98-38e00bf38dd8/etsy-9.jpg","https://media.gemworkers.com/items/6a9f8cea-4477-43c4-8f98-38e00bf38dd8/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 130 USD, converted at ECB rate. Etsy tags: Green Tourmaline,Vibrant Tourmaline,AppleGreenTourmaline,Tourmaline jewellery,jewellers,jewellery making,jewellery supplies,jewellery findings,Oceangemsminerals,rings for women,rings for men,rings jewellery,natural stone.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('772fed25-0234-49bd-aed7-a59eb664a926', '14.15 Cts Green Tourmaline', 'Beautiful green tourmaline 

Inclusion give it special characteristics 

Looks Better In Real

14.15 Cts
19 x 10.4 x 7.9mm

Unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 179, 1, 'loose_stone', 'Tourmaline', NULL, 14.15, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/772fed25-0234-49bd-aed7-a59eb664a926/etsy-1.jpg","https://media.gemworkers.com/items/772fed25-0234-49bd-aed7-a59eb664a926/etsy-2.jpg","https://media.gemworkers.com/items/772fed25-0234-49bd-aed7-a59eb664a926/etsy-3.jpg","https://media.gemworkers.com/items/772fed25-0234-49bd-aed7-a59eb664a926/etsy-4.jpg","https://media.gemworkers.com/items/772fed25-0234-49bd-aed7-a59eb664a926/etsy-5.jpg","https://media.gemworkers.com/items/772fed25-0234-49bd-aed7-a59eb664a926/etsy-6.jpg","https://media.gemworkers.com/items/772fed25-0234-49bd-aed7-a59eb664a926/etsy-7.jpg","https://media.gemworkers.com/items/772fed25-0234-49bd-aed7-a59eb664a926/etsy-8.jpg","https://media.gemworkers.com/items/772fed25-0234-49bd-aed7-a59eb664a926/etsy-9.jpg","https://media.gemworkers.com/items/772fed25-0234-49bd-aed7-a59eb664a926/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 200 USD, converted at ECB rate. Etsy tags: Green Tourmaline,Vibrant Tourmaline,AppleGreenTourmaline,Tourmaline jewellery,jewellers,jewellery making,jewellery supplies,jewellery findings,Oceangemsminerals,rings for women,rings for men,rings jewellery,natural stone.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('32aa2a15-2ae9-4ca6-a1ca-183fce9efbb4', '2.80 Cts Ice Blue Tourmaline Pairs', 'A Very High Lustre Ice Blue Colour Tourmaline Pairs

2.80 Cts
4.8 x 3.9 x 3mm
5.4 x 3.4 x 2.6mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 179, 1, 'loose_stone', 'Tourmaline', NULL, 2.8, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/32aa2a15-2ae9-4ca6-a1ca-183fce9efbb4/etsy-1.jpg","https://media.gemworkers.com/items/32aa2a15-2ae9-4ca6-a1ca-183fce9efbb4/etsy-2.jpg","https://media.gemworkers.com/items/32aa2a15-2ae9-4ca6-a1ca-183fce9efbb4/etsy-3.jpg","https://media.gemworkers.com/items/32aa2a15-2ae9-4ca6-a1ca-183fce9efbb4/etsy-4.jpg","https://media.gemworkers.com/items/32aa2a15-2ae9-4ca6-a1ca-183fce9efbb4/etsy-5.jpg","https://media.gemworkers.com/items/32aa2a15-2ae9-4ca6-a1ca-183fce9efbb4/etsy-6.jpg","https://media.gemworkers.com/items/32aa2a15-2ae9-4ca6-a1ca-183fce9efbb4/etsy-7.jpg","https://media.gemworkers.com/items/32aa2a15-2ae9-4ca6-a1ca-183fce9efbb4/etsy-8.jpg","https://media.gemworkers.com/items/32aa2a15-2ae9-4ca6-a1ca-183fce9efbb4/etsy-9.jpg","https://media.gemworkers.com/items/32aa2a15-2ae9-4ca6-a1ca-183fce9efbb4/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 200 USD, converted at ECB rate. Etsy tags: Tourmaline Earrings,Earrings Set,Fine Tourmaline,Canary Tourmaline,Lagoon Tourmaline,Blue Tourmaline,Yellow Tourmaline,Stud Earrings,Tourmaline Jewellery,Jewellery Set,Oceangemsminerals,Tourmaline Pairs,Lagoon Pairs.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('04b97ac3-73c9-4f15-a275-2ab0c58c7990', '3.50 Cts Ice Blue Tourmaline Pairs', 'A Very High Lustre Ice Blue Colour Tourmaline Pairs

3.50 Cts
5.8 x 3.7 x 3.2mm
5.5 x 3.6 x 2.9mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 179, 1, 'loose_stone', 'Tourmaline', NULL, 3.5, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/04b97ac3-73c9-4f15-a275-2ab0c58c7990/etsy-1.jpg","https://media.gemworkers.com/items/04b97ac3-73c9-4f15-a275-2ab0c58c7990/etsy-2.jpg","https://media.gemworkers.com/items/04b97ac3-73c9-4f15-a275-2ab0c58c7990/etsy-3.jpg","https://media.gemworkers.com/items/04b97ac3-73c9-4f15-a275-2ab0c58c7990/etsy-4.jpg","https://media.gemworkers.com/items/04b97ac3-73c9-4f15-a275-2ab0c58c7990/etsy-5.jpg","https://media.gemworkers.com/items/04b97ac3-73c9-4f15-a275-2ab0c58c7990/etsy-6.jpg","https://media.gemworkers.com/items/04b97ac3-73c9-4f15-a275-2ab0c58c7990/etsy-7.jpg","https://media.gemworkers.com/items/04b97ac3-73c9-4f15-a275-2ab0c58c7990/etsy-8.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 200 USD, converted at ECB rate. Etsy tags: Tourmaline Earrings,Earrings Set,Fine Tourmaline,Canary Tourmaline,Lagoon Tourmaline,Blue Tourmaline,Yellow Tourmaline,Stud Earrings,Tourmaline Jewellery,Jewellery Set,Oceangemsminerals,Tourmaline Pairs,Lagoon Pairs.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('ccebfb5c-540e-4076-aabd-9e124bcdeb95', '9.40 Cts Natural Bicolour Afghan Tourmaline', 'Gorgeous Mesmerising Natural Bicolour Afghan Tourmaline

high lustre, Saturated Colour

9.40 Cts
10.5 x 10.8 x 8.6mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 268, 1, 'loose_stone', 'Tourmaline', NULL, 9.4, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/ccebfb5c-540e-4076-aabd-9e124bcdeb95/etsy-1.jpg","https://media.gemworkers.com/items/ccebfb5c-540e-4076-aabd-9e124bcdeb95/etsy-2.jpg","https://media.gemworkers.com/items/ccebfb5c-540e-4076-aabd-9e124bcdeb95/etsy-3.jpg","https://media.gemworkers.com/items/ccebfb5c-540e-4076-aabd-9e124bcdeb95/etsy-4.jpg","https://media.gemworkers.com/items/ccebfb5c-540e-4076-aabd-9e124bcdeb95/etsy-5.jpg","https://media.gemworkers.com/items/ccebfb5c-540e-4076-aabd-9e124bcdeb95/etsy-6.jpg","https://media.gemworkers.com/items/ccebfb5c-540e-4076-aabd-9e124bcdeb95/etsy-7.jpg","https://media.gemworkers.com/items/ccebfb5c-540e-4076-aabd-9e124bcdeb95/etsy-8.jpg","https://media.gemworkers.com/items/ccebfb5c-540e-4076-aabd-9e124bcdeb95/etsy-9.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 300 USD, converted at ECB rate. Etsy tags: Tourmaline Rings,rings for women,rings for men,jewellery making,jewellery findings,gift for her,natural stone,Oceangemsminerals,apple green colour,Bicolour Tourmaline,Natural Bicolour,Unheated Tourmaline,Lipstick Tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('b8da6ad2-ec97-4c73-bdeb-4ecf59b9641e', '18 Cts Hot Pink Rubelite Tourmaline', 'Gorgeous Hot Pink Rubelite Tourmaline 

Big Size And Very Best Price

18 Cts
16 x 14.7 x 9.8mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 1787, 1, 'loose_stone', 'Tourmaline', 'Rubellite', 18, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/b8da6ad2-ec97-4c73-bdeb-4ecf59b9641e/etsy-1.jpg","https://media.gemworkers.com/items/b8da6ad2-ec97-4c73-bdeb-4ecf59b9641e/etsy-2.jpg","https://media.gemworkers.com/items/b8da6ad2-ec97-4c73-bdeb-4ecf59b9641e/etsy-3.jpg","https://media.gemworkers.com/items/b8da6ad2-ec97-4c73-bdeb-4ecf59b9641e/etsy-4.jpg","https://media.gemworkers.com/items/b8da6ad2-ec97-4c73-bdeb-4ecf59b9641e/etsy-5.jpg","https://media.gemworkers.com/items/b8da6ad2-ec97-4c73-bdeb-4ecf59b9641e/etsy-6.jpg","https://media.gemworkers.com/items/b8da6ad2-ec97-4c73-bdeb-4ecf59b9641e/etsy-7.jpg","https://media.gemworkers.com/items/b8da6ad2-ec97-4c73-bdeb-4ecf59b9641e/etsy-8.jpg","https://media.gemworkers.com/items/b8da6ad2-ec97-4c73-bdeb-4ecf59b9641e/etsy-9.jpg","https://media.gemworkers.com/items/b8da6ad2-ec97-4c73-bdeb-4ecf59b9641e/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 2000 USD, converted at ECB rate. Etsy tags: Red Tourmaline,Hot Pink Tourmaline,Pink Tourmaline,Orange Tourmaline,Unique Tourmaline,Tourmaline Rings,Tourmaline Jewellery,Faceted Tourmaline,Step Cushion Cut,Afghan Tourmaline,Oceangemsminerals,Pink Rubelite,Red Rubelite.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('05b0b21b-cb58-4a6f-86de-3840a637ecc5', '4.5 Cts Bicolour Tourmaline', 'Sweet Natural Bicolour Tourmaline 

Unique And Rare Colour

4.5 Cts
10.8 x 7.8 x 5.6mm

No treatment.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 581, 1, 'loose_stone', 'Tourmaline', NULL, 4.5, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/05b0b21b-cb58-4a6f-86de-3840a637ecc5/etsy-1.jpg","https://media.gemworkers.com/items/05b0b21b-cb58-4a6f-86de-3840a637ecc5/etsy-2.jpg","https://media.gemworkers.com/items/05b0b21b-cb58-4a6f-86de-3840a637ecc5/etsy-3.jpg","https://media.gemworkers.com/items/05b0b21b-cb58-4a6f-86de-3840a637ecc5/etsy-4.jpg","https://media.gemworkers.com/items/05b0b21b-cb58-4a6f-86de-3840a637ecc5/etsy-5.jpg","https://media.gemworkers.com/items/05b0b21b-cb58-4a6f-86de-3840a637ecc5/etsy-6.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 650 USD, converted at ECB rate. Etsy tags: Tourmaline Jewellery,Tourmaline Earrings,Earrings Stud,y2k earrings stud,Gold Rings,Natural Stone,Gift For Her,Rings For Men,Oceangemsminerals,lagoon tourmaline,tourmaline pairs,bicolour tourmaline,Watermelon Bicolour.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('4b2df736-db91-407f-8b7a-c5f7499e1964', '18.45 Cts Bicolour Tourmaline', 'Sweet Bicolour Tourmaline 

Unique And Rare Colour

Colour Is More Beautiful And Stronger Than Pictures 

18.45 Cts
6.5mm to 15mm

No treatment.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 1027, 1, 'loose_stone', 'Tourmaline', NULL, 18.45, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/4b2df736-db91-407f-8b7a-c5f7499e1964/etsy-1.jpg","https://media.gemworkers.com/items/4b2df736-db91-407f-8b7a-c5f7499e1964/etsy-2.jpg","https://media.gemworkers.com/items/4b2df736-db91-407f-8b7a-c5f7499e1964/etsy-3.jpg","https://media.gemworkers.com/items/4b2df736-db91-407f-8b7a-c5f7499e1964/etsy-4.jpg","https://media.gemworkers.com/items/4b2df736-db91-407f-8b7a-c5f7499e1964/etsy-5.jpg","https://media.gemworkers.com/items/4b2df736-db91-407f-8b7a-c5f7499e1964/etsy-6.jpg","https://media.gemworkers.com/items/4b2df736-db91-407f-8b7a-c5f7499e1964/etsy-7.jpg","https://media.gemworkers.com/items/4b2df736-db91-407f-8b7a-c5f7499e1964/etsy-8.jpg","https://media.gemworkers.com/items/4b2df736-db91-407f-8b7a-c5f7499e1964/etsy-9.jpg","https://media.gemworkers.com/items/4b2df736-db91-407f-8b7a-c5f7499e1964/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 1150 USD, converted at ECB rate. Etsy tags: Tourmaline Jewellery,Tourmaline Earrings,Earrings Stud,y2k earrings stud,Gold Rings,Natural Stone,Gift For Her,Rings For Men,Oceangemsminerals,lagoon tourmaline,tourmaline pairs,bicolour tourmaline,Watermelon Bicolour.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('6f2a5ae5-ebb5-4652-9b13-19f4a87e490a', '1.30 Cts Bicolour Tourmaline', 'Sweet Bicolour Tourmaline 

Unique And Rare Colour

Colour Is More Beautiful And Stronger Than Pictures 

1.30 Cts
9 x 4.7 x 4mm

No treatment.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 222, 1, 'loose_stone', 'Tourmaline', NULL, 1.3, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/6f2a5ae5-ebb5-4652-9b13-19f4a87e490a/etsy-1.jpg","https://media.gemworkers.com/items/6f2a5ae5-ebb5-4652-9b13-19f4a87e490a/etsy-2.jpg","https://media.gemworkers.com/items/6f2a5ae5-ebb5-4652-9b13-19f4a87e490a/etsy-3.jpg","https://media.gemworkers.com/items/6f2a5ae5-ebb5-4652-9b13-19f4a87e490a/etsy-4.jpg","https://media.gemworkers.com/items/6f2a5ae5-ebb5-4652-9b13-19f4a87e490a/etsy-5.jpg","https://media.gemworkers.com/items/6f2a5ae5-ebb5-4652-9b13-19f4a87e490a/etsy-6.jpg","https://media.gemworkers.com/items/6f2a5ae5-ebb5-4652-9b13-19f4a87e490a/etsy-7.jpg","https://media.gemworkers.com/items/6f2a5ae5-ebb5-4652-9b13-19f4a87e490a/etsy-8.jpg","https://media.gemworkers.com/items/6f2a5ae5-ebb5-4652-9b13-19f4a87e490a/etsy-9.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 249 USD, converted at ECB rate. Etsy tags: Tourmaline Jewellery,Tourmaline Earrings,Earrings Stud,y2k earrings stud,Gold Rings,Natural Stone,Gift For Her,Rings For Men,Oceangemsminerals,lagoon tourmaline,tourmaline pairs,bicolour tourmaline,Watermelon Bicolour.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('578f9d4b-73bc-4a58-82c5-6bbfb543e022', '1.25 Cts Bicolour Tourmaline', 'Sweet Bicolour Tourmaline 

Unique And Rare Colour

Colour Is More Beautiful And Stronger Than Pictures 

1.25 Cts
11 x 4 x 3.5mm

No treatment.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 178, 1, 'loose_stone', 'Tourmaline', NULL, 1.25, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/578f9d4b-73bc-4a58-82c5-6bbfb543e022/etsy-1.jpg","https://media.gemworkers.com/items/578f9d4b-73bc-4a58-82c5-6bbfb543e022/etsy-2.jpg","https://media.gemworkers.com/items/578f9d4b-73bc-4a58-82c5-6bbfb543e022/etsy-3.jpg","https://media.gemworkers.com/items/578f9d4b-73bc-4a58-82c5-6bbfb543e022/etsy-4.jpg","https://media.gemworkers.com/items/578f9d4b-73bc-4a58-82c5-6bbfb543e022/etsy-5.jpg","https://media.gemworkers.com/items/578f9d4b-73bc-4a58-82c5-6bbfb543e022/etsy-6.jpg","https://media.gemworkers.com/items/578f9d4b-73bc-4a58-82c5-6bbfb543e022/etsy-7.jpg","https://media.gemworkers.com/items/578f9d4b-73bc-4a58-82c5-6bbfb543e022/etsy-8.jpg","https://media.gemworkers.com/items/578f9d4b-73bc-4a58-82c5-6bbfb543e022/etsy-9.jpg","https://media.gemworkers.com/items/578f9d4b-73bc-4a58-82c5-6bbfb543e022/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 199 USD, converted at ECB rate. Etsy tags: Tourmaline Jewellery,Tourmaline Earrings,Earrings Stud,y2k earrings stud,Gold Rings,Natural Stone,Gift For Her,Rings For Men,Oceangemsminerals,lagoon tourmaline,tourmaline pairs,bicolour tourmaline,Watermelon Bicolour.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('962d17d3-81ef-485c-b867-5e4c44e295f9', '6.85 Cts Natural Bicolour Afghan Tourmalines', 'Gorgeous Mesmerising Natural Bicolour Afghan Tourmaline

high lustre, Saturated Colour

6.85 Cts
12 x 8.6 x 6.9mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 268, 1, 'loose_stone', 'Tourmaline', NULL, 6.85, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/962d17d3-81ef-485c-b867-5e4c44e295f9/etsy-1.jpg","https://media.gemworkers.com/items/962d17d3-81ef-485c-b867-5e4c44e295f9/etsy-2.jpg","https://media.gemworkers.com/items/962d17d3-81ef-485c-b867-5e4c44e295f9/etsy-3.jpg","https://media.gemworkers.com/items/962d17d3-81ef-485c-b867-5e4c44e295f9/etsy-4.jpg","https://media.gemworkers.com/items/962d17d3-81ef-485c-b867-5e4c44e295f9/etsy-5.jpg","https://media.gemworkers.com/items/962d17d3-81ef-485c-b867-5e4c44e295f9/etsy-6.jpg","https://media.gemworkers.com/items/962d17d3-81ef-485c-b867-5e4c44e295f9/etsy-7.jpg","https://media.gemworkers.com/items/962d17d3-81ef-485c-b867-5e4c44e295f9/etsy-8.jpg","https://media.gemworkers.com/items/962d17d3-81ef-485c-b867-5e4c44e295f9/etsy-9.jpg","https://media.gemworkers.com/items/962d17d3-81ef-485c-b867-5e4c44e295f9/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 300 USD, converted at ECB rate. Etsy tags: Tourmaline Rings,rings for women,rings for men,jewellery making,jewellery findings,gift for her,natural stone,Oceangemsminerals,apple green colour,Bicolour Tourmaline,Natural Bicolour,Unheated Tourmaline,Lipstick Tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('a4d9278b-b48b-490d-9b3e-3d5b1fd381f1', '6 Cts, Seafoam Tourmalines.', 'Gorgeous 3 different Seafoam Colour Mesmerising Afghan Tourmaline 

amazing one of a kind colour. very gorgeous looking.

6 Cts
8 x 4.5 x 4mm
13 x 4 x 3.5mm

unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 197, 1, 'loose_stone', 'Tourmaline', NULL, 6, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/a4d9278b-b48b-490d-9b3e-3d5b1fd381f1/etsy-1.jpg","https://media.gemworkers.com/items/a4d9278b-b48b-490d-9b3e-3d5b1fd381f1/etsy-2.jpg","https://media.gemworkers.com/items/a4d9278b-b48b-490d-9b3e-3d5b1fd381f1/etsy-3.jpg","https://media.gemworkers.com/items/a4d9278b-b48b-490d-9b3e-3d5b1fd381f1/etsy-4.jpg","https://media.gemworkers.com/items/a4d9278b-b48b-490d-9b3e-3d5b1fd381f1/etsy-5.jpg","https://media.gemworkers.com/items/a4d9278b-b48b-490d-9b3e-3d5b1fd381f1/etsy-6.jpg","https://media.gemworkers.com/items/a4d9278b-b48b-490d-9b3e-3d5b1fd381f1/etsy-7.jpg","https://media.gemworkers.com/items/a4d9278b-b48b-490d-9b3e-3d5b1fd381f1/etsy-8.jpg","https://media.gemworkers.com/items/a4d9278b-b48b-490d-9b3e-3d5b1fd381f1/etsy-9.jpg","https://media.gemworkers.com/items/a4d9278b-b48b-490d-9b3e-3d5b1fd381f1/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 220 USD, converted at ECB rate. Etsy tags: Gold rings,tourmaline jewellery,blue tourmaline,ink blue colours,gift for her,jewellery making,rings for women,rings for men,stud rings,seafoam blue,seafoam tourmaline,lagoon tourmaline,Oceangemsminerals.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('49625e7b-77f6-4bc7-a765-0ebd9d26103b', '47 Cts Hot Pink Tourmaline Cabochon Lot', 'Gorgeous Hot Pink Colour Tourmaline Cabochon Lot

High Lustre And Nice Polished

47 Cts
7 to 15.5mm

unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 313, 1, 'loose_stone', 'Tourmaline', NULL, 47, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/49625e7b-77f6-4bc7-a765-0ebd9d26103b/etsy-1.jpg","https://media.gemworkers.com/items/49625e7b-77f6-4bc7-a765-0ebd9d26103b/etsy-2.jpg","https://media.gemworkers.com/items/49625e7b-77f6-4bc7-a765-0ebd9d26103b/etsy-3.jpg","https://media.gemworkers.com/items/49625e7b-77f6-4bc7-a765-0ebd9d26103b/etsy-4.jpg","https://media.gemworkers.com/items/49625e7b-77f6-4bc7-a765-0ebd9d26103b/etsy-5.jpg","https://media.gemworkers.com/items/49625e7b-77f6-4bc7-a765-0ebd9d26103b/etsy-6.jpg","https://media.gemworkers.com/items/49625e7b-77f6-4bc7-a765-0ebd9d26103b/etsy-7.jpg","https://media.gemworkers.com/items/49625e7b-77f6-4bc7-a765-0ebd9d26103b/etsy-8.jpg","https://media.gemworkers.com/items/49625e7b-77f6-4bc7-a765-0ebd9d26103b/etsy-9.jpg","https://media.gemworkers.com/items/49625e7b-77f6-4bc7-a765-0ebd9d26103b/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 350 USD, converted at ECB rate. Etsy tags: Santa Maria Cabochon,Bicolour Cabochons,Blue Cabochons,Lagoon Cabochons,Natural Stone,jewels,Oceangemsminerals,Tourmaline Rosecuts,Lagoon Rosecuts,Blue Tourmaline,Blue Rosecuts,Pink Cabochon,Green Cabochon.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('6fbd1796-936e-46bb-a3e0-90fabe256faa', '1.05 Cts Ink Blue Tourmaline Pair', 'Top Ink Blue Colour Tourmaline Emerald Cut 

For Earrings And Can Also Be used as side stones

1.05 Cts
5.8 x 3.5 x 2.8mm

No Treatment Whatsoever.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 179, 1, 'loose_stone', 'Tourmaline', NULL, 1.05, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/6fbd1796-936e-46bb-a3e0-90fabe256faa/etsy-1.jpg","https://media.gemworkers.com/items/6fbd1796-936e-46bb-a3e0-90fabe256faa/etsy-2.jpg","https://media.gemworkers.com/items/6fbd1796-936e-46bb-a3e0-90fabe256faa/etsy-3.jpg","https://media.gemworkers.com/items/6fbd1796-936e-46bb-a3e0-90fabe256faa/etsy-4.jpg","https://media.gemworkers.com/items/6fbd1796-936e-46bb-a3e0-90fabe256faa/etsy-5.jpg","https://media.gemworkers.com/items/6fbd1796-936e-46bb-a3e0-90fabe256faa/etsy-6.jpg","https://media.gemworkers.com/items/6fbd1796-936e-46bb-a3e0-90fabe256faa/etsy-7.jpg","https://media.gemworkers.com/items/6fbd1796-936e-46bb-a3e0-90fabe256faa/etsy-8.jpg","https://media.gemworkers.com/items/6fbd1796-936e-46bb-a3e0-90fabe256faa/etsy-9.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 200 USD, converted at ECB rate. Etsy tags: Emerald Cut,EmeraldCutTourmaline,Jewellery making,earrings stud,Tourmaline Lot,Blue Tourmaline,Lagoon Tourmaline,Neon Blue,neon blue tourmaline,Rings For Men,Tourmalines,Ink Blue Tourmaline,Oceangemsminerals.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('1fb36def-ab66-4a7f-b2aa-8d0c5984c048', '1.3 Cts Reverse Tourmaline Pair', 'lagoon and White colour tourmaline Reverse Pair

top colour high lustre and brilliance 

Paraiba Like Colour

1.30 Cts 
4.8 x 4.6 x 3.9mm

100% natural no treatment whatsoever.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 313, 1, 'loose_stone', 'Tourmaline', NULL, 1.3, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/1fb36def-ab66-4a7f-b2aa-8d0c5984c048/etsy-1.jpg","https://media.gemworkers.com/items/1fb36def-ab66-4a7f-b2aa-8d0c5984c048/etsy-2.jpg","https://media.gemworkers.com/items/1fb36def-ab66-4a7f-b2aa-8d0c5984c048/etsy-3.jpg","https://media.gemworkers.com/items/1fb36def-ab66-4a7f-b2aa-8d0c5984c048/etsy-4.jpg","https://media.gemworkers.com/items/1fb36def-ab66-4a7f-b2aa-8d0c5984c048/etsy-5.jpg","https://media.gemworkers.com/items/1fb36def-ab66-4a7f-b2aa-8d0c5984c048/etsy-6.jpg","https://media.gemworkers.com/items/1fb36def-ab66-4a7f-b2aa-8d0c5984c048/etsy-7.jpg","https://media.gemworkers.com/items/1fb36def-ab66-4a7f-b2aa-8d0c5984c048/etsy-8.jpg","https://media.gemworkers.com/items/1fb36def-ab66-4a7f-b2aa-8d0c5984c048/etsy-9.jpg","https://media.gemworkers.com/items/1fb36def-ab66-4a7f-b2aa-8d0c5984c048/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 350 USD, converted at ECB rate. Etsy tags: Natural Stone,Jewellery Supplies,Jewellery Making,Jewellery Findings,y2k stud earrings,Gift For Her,Rings For Men,Rings For Women,Gold Rings,Silver Sterling,Garnet Necklace,Garnet Rings,Garnet Jewellery.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('26ad65e1-e81b-4764-acd6-bf4dc42e8618', '4.05 Cts Blue Tourmaline Lot', 'Top Blue Afghan Tourmaline Lot 

High Lustre And Best Colour

4.05 Cts
5.5 to 3.3mm

Unheated,Untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 356, 1, 'loose_stone', 'Tourmaline', NULL, 4.05, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/26ad65e1-e81b-4764-acd6-bf4dc42e8618/etsy-1.jpg","https://media.gemworkers.com/items/26ad65e1-e81b-4764-acd6-bf4dc42e8618/etsy-2.jpg","https://media.gemworkers.com/items/26ad65e1-e81b-4764-acd6-bf4dc42e8618/etsy-3.jpg","https://media.gemworkers.com/items/26ad65e1-e81b-4764-acd6-bf4dc42e8618/etsy-4.jpg","https://media.gemworkers.com/items/26ad65e1-e81b-4764-acd6-bf4dc42e8618/etsy-5.jpg","https://media.gemworkers.com/items/26ad65e1-e81b-4764-acd6-bf4dc42e8618/etsy-6.jpg","https://media.gemworkers.com/items/26ad65e1-e81b-4764-acd6-bf4dc42e8618/etsy-7.jpg","https://media.gemworkers.com/items/26ad65e1-e81b-4764-acd6-bf4dc42e8618/etsy-8.jpg","https://media.gemworkers.com/items/26ad65e1-e81b-4764-acd6-bf4dc42e8618/etsy-9.jpg","https://media.gemworkers.com/items/26ad65e1-e81b-4764-acd6-bf4dc42e8618/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 399 USD, converted at ECB rate. Etsy tags: Jewellery Making,Jewellery Supplies,Gemstones Jewellery,Jewellery Findings,Gift for her,Rings For Women,Rings For Men,Gold Rings,Jewels,Bluegreen tourmaline,neon tourmaline,lagoon tourmaline,mintgreentourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('f78b7a03-f8fc-402d-844c-72f10932498c', '5.3 Cts Mix Colour Tourmaline Lot', 'Gorgeous Mesmerising Afghan Tourmaline lot,

Unique Colour, glossy and high lustre.

best for jewellery 

5.30 Cts
6 to 4mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 259, 1, 'loose_stone', 'Tourmaline', NULL, 5.3, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/f78b7a03-f8fc-402d-844c-72f10932498c/etsy-1.jpg","https://media.gemworkers.com/items/f78b7a03-f8fc-402d-844c-72f10932498c/etsy-2.jpg","https://media.gemworkers.com/items/f78b7a03-f8fc-402d-844c-72f10932498c/etsy-3.jpg","https://media.gemworkers.com/items/f78b7a03-f8fc-402d-844c-72f10932498c/etsy-4.jpg","https://media.gemworkers.com/items/f78b7a03-f8fc-402d-844c-72f10932498c/etsy-5.jpg","https://media.gemworkers.com/items/f78b7a03-f8fc-402d-844c-72f10932498c/etsy-6.jpg","https://media.gemworkers.com/items/f78b7a03-f8fc-402d-844c-72f10932498c/etsy-7.jpg","https://media.gemworkers.com/items/f78b7a03-f8fc-402d-844c-72f10932498c/etsy-8.jpg","https://media.gemworkers.com/items/f78b7a03-f8fc-402d-844c-72f10932498c/etsy-9.jpg","https://media.gemworkers.com/items/f78b7a03-f8fc-402d-844c-72f10932498c/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 290 USD, converted at ECB rate. Etsy tags: BlueGreen Tourmaline,Blue Tourmaline,Green Tourmaline,Lagoon Tourmaline,Tourmaline Rings,rings for women,rings for men,jewellery making,jewellery findings,gift for her,natural stone,Oceangemsminerals,apple green colour.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('32219add-7e34-44c8-a6be-4118ceeb002f', '1.45 Cts Tourmaline Pair.', 'Gorgeous Pink Tourmaline Pair

1.45 Cts
6.9mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 89, 1, 'loose_stone', 'Tourmaline', NULL, 1.45, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/32219add-7e34-44c8-a6be-4118ceeb002f/etsy-1.jpg","https://media.gemworkers.com/items/32219add-7e34-44c8-a6be-4118ceeb002f/etsy-2.jpg","https://media.gemworkers.com/items/32219add-7e34-44c8-a6be-4118ceeb002f/etsy-3.jpg","https://media.gemworkers.com/items/32219add-7e34-44c8-a6be-4118ceeb002f/etsy-4.jpg","https://media.gemworkers.com/items/32219add-7e34-44c8-a6be-4118ceeb002f/etsy-5.jpg","https://media.gemworkers.com/items/32219add-7e34-44c8-a6be-4118ceeb002f/etsy-6.jpg","https://media.gemworkers.com/items/32219add-7e34-44c8-a6be-4118ceeb002f/etsy-7.jpg","https://media.gemworkers.com/items/32219add-7e34-44c8-a6be-4118ceeb002f/etsy-8.jpg","https://media.gemworkers.com/items/32219add-7e34-44c8-a6be-4118ceeb002f/etsy-9.jpg","https://media.gemworkers.com/items/32219add-7e34-44c8-a6be-4118ceeb002f/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 100 USD, converted at ECB rate. Etsy tags: pink tourmaline,rings for women,unique tourmaline,jewels,Handmadejewellery,gift for her,Topqualitytourmaline,Bicolour Tourmaline,Unique Bicolour,Rare Tourmaline,Oceangemsminerals,Tourmaline Pairs,Bicolour Pairs.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('a2ee85f1-2c05-4cb1-a2f8-34757ffcd88a', '0.5 Cts, Natural Bicolour Afghan Tourmaline Pair', 'Gorgeous Mesmerising Natural Bicolour Afghan Tourmaline pair

high lustre, Saturated Colour.

0.5 Cts
5.8mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 89, 1, 'loose_stone', 'Tourmaline', NULL, 0.5, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/a2ee85f1-2c05-4cb1-a2f8-34757ffcd88a/etsy-1.jpg","https://media.gemworkers.com/items/a2ee85f1-2c05-4cb1-a2f8-34757ffcd88a/etsy-2.jpg","https://media.gemworkers.com/items/a2ee85f1-2c05-4cb1-a2f8-34757ffcd88a/etsy-3.jpg","https://media.gemworkers.com/items/a2ee85f1-2c05-4cb1-a2f8-34757ffcd88a/etsy-4.jpg","https://media.gemworkers.com/items/a2ee85f1-2c05-4cb1-a2f8-34757ffcd88a/etsy-5.jpg","https://media.gemworkers.com/items/a2ee85f1-2c05-4cb1-a2f8-34757ffcd88a/etsy-6.jpg","https://media.gemworkers.com/items/a2ee85f1-2c05-4cb1-a2f8-34757ffcd88a/etsy-7.jpg","https://media.gemworkers.com/items/a2ee85f1-2c05-4cb1-a2f8-34757ffcd88a/etsy-8.jpg","https://media.gemworkers.com/items/a2ee85f1-2c05-4cb1-a2f8-34757ffcd88a/etsy-9.jpg","https://media.gemworkers.com/items/a2ee85f1-2c05-4cb1-a2f8-34757ffcd88a/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 100 USD, converted at ECB rate. Etsy tags: Tourmaline Rings,rings for women,rings for men,jewellery making,jewellery findings,gift for her,natural stone,Oceangemsminerals,apple green colour,Bicolour Tourmaline,Natural Bicolour,Unheated Tourmaline,Lipstick Tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('20e6e4ee-70b1-401e-8af3-9d779cd27394', '2.70 Cts Bluegreen Tourmaline', 'Unique Bluegreen Colour Tourmaline Pair 

ethically sourced

2.70 Cts
15 x 5 x 3mm

no treatment', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 170, 1, 'loose_stone', 'Tourmaline', NULL, 2.7, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/20e6e4ee-70b1-401e-8af3-9d779cd27394/etsy-1.jpg","https://media.gemworkers.com/items/20e6e4ee-70b1-401e-8af3-9d779cd27394/etsy-2.jpg","https://media.gemworkers.com/items/20e6e4ee-70b1-401e-8af3-9d779cd27394/etsy-3.jpg","https://media.gemworkers.com/items/20e6e4ee-70b1-401e-8af3-9d779cd27394/etsy-4.jpg","https://media.gemworkers.com/items/20e6e4ee-70b1-401e-8af3-9d779cd27394/etsy-5.jpg","https://media.gemworkers.com/items/20e6e4ee-70b1-401e-8af3-9d779cd27394/etsy-6.jpg","https://media.gemworkers.com/items/20e6e4ee-70b1-401e-8af3-9d779cd27394/etsy-7.jpg","https://media.gemworkers.com/items/20e6e4ee-70b1-401e-8af3-9d779cd27394/etsy-8.jpg","https://media.gemworkers.com/items/20e6e4ee-70b1-401e-8af3-9d779cd27394/etsy-9.jpg","https://media.gemworkers.com/items/20e6e4ee-70b1-401e-8af3-9d779cd27394/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 190 USD, converted at ECB rate. Etsy tags: Jewellery Making,hoop earrings,Blue tourmaline Pair,blue tourmaline,tourmaline pairs,natural stone,jewels,handmade,loose gemstones,Bluegreen Tourmaline,Lagoon Tourmaline,Neon Blue Tourmaline,Unique Tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('f6e673af-910a-42ac-ac57-732bbc649f79', '4.60 Cts Seafoam Bicolour Tourmaline', 'Seafoam bicolour Colour Tourmaline,

Glowing lustre 

4.60 Cts
16mm long

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 223, 1, 'loose_stone', 'Tourmaline', NULL, 4.6, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/f6e673af-910a-42ac-ac57-732bbc649f79/etsy-1.jpg","https://media.gemworkers.com/items/f6e673af-910a-42ac-ac57-732bbc649f79/etsy-2.jpg","https://media.gemworkers.com/items/f6e673af-910a-42ac-ac57-732bbc649f79/etsy-3.jpg","https://media.gemworkers.com/items/f6e673af-910a-42ac-ac57-732bbc649f79/etsy-4.jpg","https://media.gemworkers.com/items/f6e673af-910a-42ac-ac57-732bbc649f79/etsy-5.jpg","https://media.gemworkers.com/items/f6e673af-910a-42ac-ac57-732bbc649f79/etsy-6.jpg","https://media.gemworkers.com/items/f6e673af-910a-42ac-ac57-732bbc649f79/etsy-7.jpg","https://media.gemworkers.com/items/f6e673af-910a-42ac-ac57-732bbc649f79/etsy-8.jpg","https://media.gemworkers.com/items/f6e673af-910a-42ac-ac57-732bbc649f79/etsy-9.jpg","https://media.gemworkers.com/items/f6e673af-910a-42ac-ac57-732bbc649f79/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 250 USD, converted at ECB rate. Etsy tags: Blue Tourmaline,Seafoam Tourmaline,Mint Tourmaline,Jewels,Unheated,Natural Stone,Jewellery making,Gift for her,Gold Rings,Handmadejewellery,Cushion,lagoon tourmaline,neon blue tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('feef110e-7632-4c95-9d54-e533fa06d864', '21.6 Cts Malaya Garnet Lot', 'High Quality Malaya Garnet Lot

High Lustre And Brilliance 

21.60 Cts
8.8 to 6mm

No treatment.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 536, 1, 'loose_stone', 'Garnet', NULL, 21.6, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/feef110e-7632-4c95-9d54-e533fa06d864/etsy-1.jpg","https://media.gemworkers.com/items/feef110e-7632-4c95-9d54-e533fa06d864/etsy-2.jpg","https://media.gemworkers.com/items/feef110e-7632-4c95-9d54-e533fa06d864/etsy-3.jpg","https://media.gemworkers.com/items/feef110e-7632-4c95-9d54-e533fa06d864/etsy-4.jpg","https://media.gemworkers.com/items/feef110e-7632-4c95-9d54-e533fa06d864/etsy-5.jpg","https://media.gemworkers.com/items/feef110e-7632-4c95-9d54-e533fa06d864/etsy-6.jpg","https://media.gemworkers.com/items/feef110e-7632-4c95-9d54-e533fa06d864/etsy-7.jpg","https://media.gemworkers.com/items/feef110e-7632-4c95-9d54-e533fa06d864/etsy-8.jpg","https://media.gemworkers.com/items/feef110e-7632-4c95-9d54-e533fa06d864/etsy-9.jpg","https://media.gemworkers.com/items/feef110e-7632-4c95-9d54-e533fa06d864/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 600 USD, converted at ECB rate. Etsy tags: Red Garnet,y2k earrings studs,Jewellery Supplies,Jewellery Making,Gift For Her,Rings For Women,Rings For Men,Natural Stone,Jewellery Findings,Gold Rings,Gemstones Jewellery,Garnet Jewellery,Garnet Lot.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('7ebc9de3-bb71-4846-ab26-0cc631b4f5b5', '2.20 Cts Lagoon and neon blue tourmaline', 'lagoon and neon blue colour tourmalines

top colour high lustre and brilliance 

2.20 Cts
3.5 to 5.9mm

100% natural no treatment whatsoever.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 179, 1, 'loose_stone', 'Tourmaline', NULL, 2.2, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/7ebc9de3-bb71-4846-ab26-0cc631b4f5b5/etsy-1.jpg","https://media.gemworkers.com/items/7ebc9de3-bb71-4846-ab26-0cc631b4f5b5/etsy-2.jpg","https://media.gemworkers.com/items/7ebc9de3-bb71-4846-ab26-0cc631b4f5b5/etsy-3.jpg","https://media.gemworkers.com/items/7ebc9de3-bb71-4846-ab26-0cc631b4f5b5/etsy-4.jpg","https://media.gemworkers.com/items/7ebc9de3-bb71-4846-ab26-0cc631b4f5b5/etsy-5.jpg","https://media.gemworkers.com/items/7ebc9de3-bb71-4846-ab26-0cc631b4f5b5/etsy-6.jpg","https://media.gemworkers.com/items/7ebc9de3-bb71-4846-ab26-0cc631b4f5b5/etsy-7.jpg","https://media.gemworkers.com/items/7ebc9de3-bb71-4846-ab26-0cc631b4f5b5/etsy-8.jpg","https://media.gemworkers.com/items/7ebc9de3-bb71-4846-ab26-0cc631b4f5b5/etsy-9.jpg","https://media.gemworkers.com/items/7ebc9de3-bb71-4846-ab26-0cc631b4f5b5/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 200 USD, converted at ECB rate. Etsy tags: Natural Stone,Jewellery Supplies,Jewellery Making,Jewellery Findings,y2k stud earrings,Gift For Her,Rings For Men,Rings For Women,Gold Rings,Silver Sterling,Garnet Necklace,Garnet Rings,Garnet Jewellery.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('9d04c23f-60c6-46c8-9e6b-ae0787f5ca2e', '11.45 Cts Hot Pink Tourmaline Lot', 'Gorgeous Hot Pink Tourmaline 

very rare colour, just like spinel

11.45 carats 

Size:6.9x4.8x3.3mm to 4.2x3.6x2.7mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 356, 1, 'loose_stone', 'Tourmaline', NULL, 11.45, 'ct', NULL, NULL, '6.9x4.8x3.3', '["https://media.gemworkers.com/items/9d04c23f-60c6-46c8-9e6b-ae0787f5ca2e/etsy-1.jpg","https://media.gemworkers.com/items/9d04c23f-60c6-46c8-9e6b-ae0787f5ca2e/etsy-2.jpg","https://media.gemworkers.com/items/9d04c23f-60c6-46c8-9e6b-ae0787f5ca2e/etsy-3.jpg","https://media.gemworkers.com/items/9d04c23f-60c6-46c8-9e6b-ae0787f5ca2e/etsy-4.jpg","https://media.gemworkers.com/items/9d04c23f-60c6-46c8-9e6b-ae0787f5ca2e/etsy-5.jpg","https://media.gemworkers.com/items/9d04c23f-60c6-46c8-9e6b-ae0787f5ca2e/etsy-6.jpg","https://media.gemworkers.com/items/9d04c23f-60c6-46c8-9e6b-ae0787f5ca2e/etsy-7.jpg","https://media.gemworkers.com/items/9d04c23f-60c6-46c8-9e6b-ae0787f5ca2e/etsy-8.jpg","https://media.gemworkers.com/items/9d04c23f-60c6-46c8-9e6b-ae0787f5ca2e/etsy-9.jpg","https://media.gemworkers.com/items/9d04c23f-60c6-46c8-9e6b-ae0787f5ca2e/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 399 USD, converted at ECB rate. Etsy tags: Red Tourmaline,Hot Pink Tourmaline,Pink Tourmaline,Orange Tourmaline,Unique Tourmaline,Tourmaline Jewellery,Faceted Tourmaline,Step Cushion Cut,Feceted Tourmaline,Afghan Tourmaline,Oceangemsminerals,Purple Tourmaline,Lavender Tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('27aac13e-d580-428e-9ac6-48ac7c22953a', '5.1 Cts Neon Blue Tourmaline Lot', 'lagoon and neon blue colour tourmaline Lot

top colour high lustre and brilliance 

5.10 Cts 
Size:3.4mm to 9mm

100% natural no treatment whatsoever.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 356, 1, 'loose_stone', 'Tourmaline', NULL, 5.1, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/27aac13e-d580-428e-9ac6-48ac7c22953a/etsy-1.jpg","https://media.gemworkers.com/items/27aac13e-d580-428e-9ac6-48ac7c22953a/etsy-2.jpg","https://media.gemworkers.com/items/27aac13e-d580-428e-9ac6-48ac7c22953a/etsy-3.jpg","https://media.gemworkers.com/items/27aac13e-d580-428e-9ac6-48ac7c22953a/etsy-4.jpg","https://media.gemworkers.com/items/27aac13e-d580-428e-9ac6-48ac7c22953a/etsy-5.jpg","https://media.gemworkers.com/items/27aac13e-d580-428e-9ac6-48ac7c22953a/etsy-6.jpg","https://media.gemworkers.com/items/27aac13e-d580-428e-9ac6-48ac7c22953a/etsy-7.jpg","https://media.gemworkers.com/items/27aac13e-d580-428e-9ac6-48ac7c22953a/etsy-8.jpg","https://media.gemworkers.com/items/27aac13e-d580-428e-9ac6-48ac7c22953a/etsy-9.jpg","https://media.gemworkers.com/items/27aac13e-d580-428e-9ac6-48ac7c22953a/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 399 USD, converted at ECB rate. Etsy tags: Natural Stone,Jewellery Supplies,Jewellery Making,Jewellery Findings,y2k stud earrings,Gift For Her,Rings For Men,Rings For Women,Gold Rings,Silver Sterling,Garnet Necklace,Garnet Rings,Garnet Jewellery.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('b7822b54-6b01-4b0f-bbc0-57bdef3e01ec', 'Pigeon Blood: 1.90 Cts Rubilite', 'Gorgeous pigeon blood colour Rubilite Tourmalines

1.90 Cts
4mm to 5mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 170, 1, 'loose_stone', 'Tourmaline', 'Rubellite', 1.9, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/b7822b54-6b01-4b0f-bbc0-57bdef3e01ec/etsy-1.jpg","https://media.gemworkers.com/items/b7822b54-6b01-4b0f-bbc0-57bdef3e01ec/etsy-2.jpg","https://media.gemworkers.com/items/b7822b54-6b01-4b0f-bbc0-57bdef3e01ec/etsy-3.jpg","https://media.gemworkers.com/items/b7822b54-6b01-4b0f-bbc0-57bdef3e01ec/etsy-4.jpg","https://media.gemworkers.com/items/b7822b54-6b01-4b0f-bbc0-57bdef3e01ec/etsy-5.jpg","https://media.gemworkers.com/items/b7822b54-6b01-4b0f-bbc0-57bdef3e01ec/etsy-6.jpg","https://media.gemworkers.com/items/b7822b54-6b01-4b0f-bbc0-57bdef3e01ec/etsy-7.jpg","https://media.gemworkers.com/items/b7822b54-6b01-4b0f-bbc0-57bdef3e01ec/etsy-8.jpg","https://media.gemworkers.com/items/b7822b54-6b01-4b0f-bbc0-57bdef3e01ec/etsy-9.jpg","https://media.gemworkers.com/items/b7822b54-6b01-4b0f-bbc0-57bdef3e01ec/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 190 USD, converted at ECB rate. Etsy tags: Red Rubilite,PigeonBlood Rubilite,Orange Rubilite,Pinkish Rubilite,Red Tourmaline,Pink Tourmaline,Orange Tourmaline,Cushion Cut,Tourmaline Jewellery,Tourmaline Faceted,Rubilite Tourmaline,Jewellery Making,Jewellery Findings.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('244c0743-1f6f-44db-880c-1fa33e1ad137', '71 Cts Panjsher Emerald Cabochons', 'Gorgeous Emerald Cabochons From Panjsher

Colour is more beautiful in real 

71 Cts
17.9 to 7.4mm

Unheated,', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 313, 1, 'loose_stone', 'Emerald', NULL, 71, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/244c0743-1f6f-44db-880c-1fa33e1ad137/etsy-1.jpg","https://media.gemworkers.com/items/244c0743-1f6f-44db-880c-1fa33e1ad137/etsy-2.jpg","https://media.gemworkers.com/items/244c0743-1f6f-44db-880c-1fa33e1ad137/etsy-3.jpg","https://media.gemworkers.com/items/244c0743-1f6f-44db-880c-1fa33e1ad137/etsy-4.jpg","https://media.gemworkers.com/items/244c0743-1f6f-44db-880c-1fa33e1ad137/etsy-5.jpg","https://media.gemworkers.com/items/244c0743-1f6f-44db-880c-1fa33e1ad137/etsy-6.jpg","https://media.gemworkers.com/items/244c0743-1f6f-44db-880c-1fa33e1ad137/etsy-7.jpg","https://media.gemworkers.com/items/244c0743-1f6f-44db-880c-1fa33e1ad137/etsy-8.jpg","https://media.gemworkers.com/items/244c0743-1f6f-44db-880c-1fa33e1ad137/etsy-9.jpg","https://media.gemworkers.com/items/244c0743-1f6f-44db-880c-1fa33e1ad137/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 350 USD, converted at ECB rate. Etsy tags: Emerald,Emerald supplies,Emerald rings,Emerald earrings,Oceangemsminerals,Gift for her,Natural stone,Jewellery making,Rings for women,Rings for men,Emerald Jewellery,Bicolour Emerald,Emerald Cabochons.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('c10aafec-5f1a-4863-a11a-06d673bc18d5', '3.10 Cts Blue Green Colour Tourmaline', 'Mesmerising Blue Green Colour Afghan Tourmaline 

Ethically sourced, 

best for ring

3.10 Cts
8.5 x 7 x 6mm

Unheated, Untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 179, 1, 'loose_stone', 'Tourmaline', NULL, 3.1, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/c10aafec-5f1a-4863-a11a-06d673bc18d5/etsy-1.jpg","https://media.gemworkers.com/items/c10aafec-5f1a-4863-a11a-06d673bc18d5/etsy-2.jpg","https://media.gemworkers.com/items/c10aafec-5f1a-4863-a11a-06d673bc18d5/etsy-3.jpg","https://media.gemworkers.com/items/c10aafec-5f1a-4863-a11a-06d673bc18d5/etsy-4.jpg","https://media.gemworkers.com/items/c10aafec-5f1a-4863-a11a-06d673bc18d5/etsy-5.jpg","https://media.gemworkers.com/items/c10aafec-5f1a-4863-a11a-06d673bc18d5/etsy-6.jpg","https://media.gemworkers.com/items/c10aafec-5f1a-4863-a11a-06d673bc18d5/etsy-7.jpg","https://media.gemworkers.com/items/c10aafec-5f1a-4863-a11a-06d673bc18d5/etsy-8.jpg","https://media.gemworkers.com/items/c10aafec-5f1a-4863-a11a-06d673bc18d5/etsy-9.jpg","https://media.gemworkers.com/items/c10aafec-5f1a-4863-a11a-06d673bc18d5/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 200 USD, converted at ECB rate. Etsy tags: Bluegreen Tourmaline,Blue Tourmaline,Green Tourmaline,Jewellery supplies,jewellery making,jewellery findings,jewels,Handmadejewellery,cushion cut,gift for her,natural stone,gold rings,silver stirring.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('784ff5f9-3d76-4f32-820d-e73345450458', '3.20 Cts Blue bicolour tourmaline', 'Unique Seafoam Bicolour Tourmalines

high lustre 

3.20 Cts
9.5mm long

no treatment.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 170, 1, 'loose_stone', 'Tourmaline', NULL, 3.2, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/784ff5f9-3d76-4f32-820d-e73345450458/etsy-1.jpg","https://media.gemworkers.com/items/784ff5f9-3d76-4f32-820d-e73345450458/etsy-2.jpg","https://media.gemworkers.com/items/784ff5f9-3d76-4f32-820d-e73345450458/etsy-3.jpg","https://media.gemworkers.com/items/784ff5f9-3d76-4f32-820d-e73345450458/etsy-4.jpg","https://media.gemworkers.com/items/784ff5f9-3d76-4f32-820d-e73345450458/etsy-5.jpg","https://media.gemworkers.com/items/784ff5f9-3d76-4f32-820d-e73345450458/etsy-6.jpg","https://media.gemworkers.com/items/784ff5f9-3d76-4f32-820d-e73345450458/etsy-7.jpg","https://media.gemworkers.com/items/784ff5f9-3d76-4f32-820d-e73345450458/etsy-8.jpg","https://media.gemworkers.com/items/784ff5f9-3d76-4f32-820d-e73345450458/etsy-9.jpg","https://media.gemworkers.com/items/784ff5f9-3d76-4f32-820d-e73345450458/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 190 USD, converted at ECB rate. Etsy tags: Blue Bicolour,Bicolour Tourmaline,Blue Tourmaline,Lavender Tourmaline,Purple Tourmaline,Lagoon tourmaline,neon blue tourmaline,jewellery making,gift for her,Natural stone,Handmadejewellery,Seafoam Tourmaline,Unique Tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('83b13381-f9c8-4db7-8e10-330e35c805c8', '2.60Cts Blue bicolour tourmaline', 'Unique Blue Bicolour Tourmaline 

2.60 Cts
12 x 5 x 4mm

no treatment.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 170, 1, 'loose_stone', 'Tourmaline', NULL, 2.6, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/83b13381-f9c8-4db7-8e10-330e35c805c8/etsy-1.jpg","https://media.gemworkers.com/items/83b13381-f9c8-4db7-8e10-330e35c805c8/etsy-2.jpg","https://media.gemworkers.com/items/83b13381-f9c8-4db7-8e10-330e35c805c8/etsy-3.jpg","https://media.gemworkers.com/items/83b13381-f9c8-4db7-8e10-330e35c805c8/etsy-4.jpg","https://media.gemworkers.com/items/83b13381-f9c8-4db7-8e10-330e35c805c8/etsy-5.jpg","https://media.gemworkers.com/items/83b13381-f9c8-4db7-8e10-330e35c805c8/etsy-6.jpg","https://media.gemworkers.com/items/83b13381-f9c8-4db7-8e10-330e35c805c8/etsy-7.jpg","https://media.gemworkers.com/items/83b13381-f9c8-4db7-8e10-330e35c805c8/etsy-8.jpg","https://media.gemworkers.com/items/83b13381-f9c8-4db7-8e10-330e35c805c8/etsy-9.jpg","https://media.gemworkers.com/items/83b13381-f9c8-4db7-8e10-330e35c805c8/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 190 USD, converted at ECB rate. Etsy tags: Blue Bicolour,Bicolour Tourmaline,Blue Tourmaline,Lavender Tourmaline,Purple Tourmaline,Lagoon tourmaline,neon blue tourmaline,jewellery making,jewellery findings,jewellery supplies,gift for her,Natural stone,Handmadejewellery.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('7765fe75-c3dc-4535-81b1-d260c5c53cac', '4.70 Cts Blue bicolour tourmaline', 'Unique Blue Bicolour Tourmaline 

4.70 Cts
20 x 6 x 4mm

no treatment.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 170, 1, 'loose_stone', 'Tourmaline', NULL, 4.7, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/7765fe75-c3dc-4535-81b1-d260c5c53cac/etsy-1.jpg","https://media.gemworkers.com/items/7765fe75-c3dc-4535-81b1-d260c5c53cac/etsy-2.jpg","https://media.gemworkers.com/items/7765fe75-c3dc-4535-81b1-d260c5c53cac/etsy-3.jpg","https://media.gemworkers.com/items/7765fe75-c3dc-4535-81b1-d260c5c53cac/etsy-4.jpg","https://media.gemworkers.com/items/7765fe75-c3dc-4535-81b1-d260c5c53cac/etsy-5.jpg","https://media.gemworkers.com/items/7765fe75-c3dc-4535-81b1-d260c5c53cac/etsy-6.jpg","https://media.gemworkers.com/items/7765fe75-c3dc-4535-81b1-d260c5c53cac/etsy-7.jpg","https://media.gemworkers.com/items/7765fe75-c3dc-4535-81b1-d260c5c53cac/etsy-8.jpg","https://media.gemworkers.com/items/7765fe75-c3dc-4535-81b1-d260c5c53cac/etsy-9.jpg","https://media.gemworkers.com/items/7765fe75-c3dc-4535-81b1-d260c5c53cac/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 190 USD, converted at ECB rate. Etsy tags: Blue Bicolour,Bicolour Tourmaline,Blue Tourmaline,Lavender Tourmaline,Purple Tourmaline,Lagoon tourmaline,neon blue tourmaline,jewellery making,jewellery findings,jewellery supplies,gift for her,Natural stone,Handmadejewellery.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('f84b7959-51d2-4363-9d98-0e6c6ab49c4e', '1.80 Cts Mint Green Tourmaline', 'High Lustre Mint Green Colour Afghan Tourmaline 

Cut To Perfection, 

1.80 Cts
7 x 6 x 5mm

Unheated, Untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 161, 1, 'loose_stone', 'Tourmaline', NULL, 1.8, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/f84b7959-51d2-4363-9d98-0e6c6ab49c4e/etsy-1.jpg","https://media.gemworkers.com/items/f84b7959-51d2-4363-9d98-0e6c6ab49c4e/etsy-2.jpg","https://media.gemworkers.com/items/f84b7959-51d2-4363-9d98-0e6c6ab49c4e/etsy-3.jpg","https://media.gemworkers.com/items/f84b7959-51d2-4363-9d98-0e6c6ab49c4e/etsy-4.jpg","https://media.gemworkers.com/items/f84b7959-51d2-4363-9d98-0e6c6ab49c4e/etsy-5.jpg","https://media.gemworkers.com/items/f84b7959-51d2-4363-9d98-0e6c6ab49c4e/etsy-6.jpg","https://media.gemworkers.com/items/f84b7959-51d2-4363-9d98-0e6c6ab49c4e/etsy-7.jpg","https://media.gemworkers.com/items/f84b7959-51d2-4363-9d98-0e6c6ab49c4e/etsy-8.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 180 USD, converted at ECB rate. Etsy tags: Jewellery Making,Jewellery Findings,Jewellery Supplies,Gift For Her,Gold Rings,Rings For Women,Rings For Men,Green Tourmaline,Tourmaline Jewellery,Bluegreen tourmaline,bicolour tourmaline,mint green tourmalin,unique tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('dd936089-847d-4a44-ab78-2381603c3ef2', '4.60 Cts Mint Seafoam  Tourmalines', 'Seafoam And Green Tourmalines

4.60 Cts
8.5 to 9mm long

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 179, 1, 'loose_stone', 'Tourmaline', NULL, 4.6, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/dd936089-847d-4a44-ab78-2381603c3ef2/etsy-1.jpg","https://media.gemworkers.com/items/dd936089-847d-4a44-ab78-2381603c3ef2/etsy-2.jpg","https://media.gemworkers.com/items/dd936089-847d-4a44-ab78-2381603c3ef2/etsy-3.jpg","https://media.gemworkers.com/items/dd936089-847d-4a44-ab78-2381603c3ef2/etsy-4.jpg","https://media.gemworkers.com/items/dd936089-847d-4a44-ab78-2381603c3ef2/etsy-5.jpg","https://media.gemworkers.com/items/dd936089-847d-4a44-ab78-2381603c3ef2/etsy-6.jpg","https://media.gemworkers.com/items/dd936089-847d-4a44-ab78-2381603c3ef2/etsy-7.jpg","https://media.gemworkers.com/items/dd936089-847d-4a44-ab78-2381603c3ef2/etsy-8.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 200 USD, converted at ECB rate. Etsy tags: Blue Tourmaline,Seafoam Tourmaline,Mint Tourmaline,Jewels,Unheated,Natural Stone,Jewellery making,Jewellery supplies,Jewellery findings,Gift for her,Gold Rings,Handmadejewellery,Cushion.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('17a71962-240c-47cb-a44a-377ac6af2c48', '4.5 Cts Hexagon Tourmaline Pairs', 'Gorgeous Long Hexagon Cut Tourmaline Pairs

High Lustre And brilliance 

4.50 Cts
18 x 3.4 x 2.9mm

100% Natural No treatment whatsoever', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 356, 1, 'loose_stone', 'Tourmaline', NULL, 4.5, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/17a71962-240c-47cb-a44a-377ac6af2c48/etsy-1.jpg","https://media.gemworkers.com/items/17a71962-240c-47cb-a44a-377ac6af2c48/etsy-2.jpg","https://media.gemworkers.com/items/17a71962-240c-47cb-a44a-377ac6af2c48/etsy-3.jpg","https://media.gemworkers.com/items/17a71962-240c-47cb-a44a-377ac6af2c48/etsy-4.jpg","https://media.gemworkers.com/items/17a71962-240c-47cb-a44a-377ac6af2c48/etsy-5.jpg","https://media.gemworkers.com/items/17a71962-240c-47cb-a44a-377ac6af2c48/etsy-6.jpg","https://media.gemworkers.com/items/17a71962-240c-47cb-a44a-377ac6af2c48/etsy-7.jpg","https://media.gemworkers.com/items/17a71962-240c-47cb-a44a-377ac6af2c48/etsy-8.jpg","https://media.gemworkers.com/items/17a71962-240c-47cb-a44a-377ac6af2c48/etsy-9.jpg","https://media.gemworkers.com/items/17a71962-240c-47cb-a44a-377ac6af2c48/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 399 USD, converted at ECB rate. Etsy tags: Tourmaline Earrings,Jewellery Making,Jewellery Findings,y2k earrings stud,Earrings findings,emerald cut,bicolour tourmaline,Tourmaline Pairs,gift for her,Natural Stone,blue tourmaline lot,Oceangemsminerals,Clean Tourmaline. Had variations on Etsy — check size/options.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('67fc34d9-3ce5-4028-a8be-d991e804e417', '2.7 Cts Hexagon Tourmaline Pairs', 'Gorgeous Long Hexagon Cut Tourmaline Pairs

High Lustre And brilliance 

2.70 Cts
13.6 x 2.9 x 2.5mm
12.4 x 2.1 x 1.8mm

100% Natural No treatment whatsoever', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 335, 1, 'loose_stone', 'Tourmaline', NULL, 2.7, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/67fc34d9-3ce5-4028-a8be-d991e804e417/etsy-1.jpg","https://media.gemworkers.com/items/67fc34d9-3ce5-4028-a8be-d991e804e417/etsy-2.jpg","https://media.gemworkers.com/items/67fc34d9-3ce5-4028-a8be-d991e804e417/etsy-3.jpg","https://media.gemworkers.com/items/67fc34d9-3ce5-4028-a8be-d991e804e417/etsy-4.jpg","https://media.gemworkers.com/items/67fc34d9-3ce5-4028-a8be-d991e804e417/etsy-5.jpg","https://media.gemworkers.com/items/67fc34d9-3ce5-4028-a8be-d991e804e417/etsy-6.jpg","https://media.gemworkers.com/items/67fc34d9-3ce5-4028-a8be-d991e804e417/etsy-7.jpg","https://media.gemworkers.com/items/67fc34d9-3ce5-4028-a8be-d991e804e417/etsy-8.jpg","https://media.gemworkers.com/items/67fc34d9-3ce5-4028-a8be-d991e804e417/etsy-9.jpg","https://media.gemworkers.com/items/67fc34d9-3ce5-4028-a8be-d991e804e417/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 375 USD, converted at ECB rate. Etsy tags: Tourmaline Earrings,Jewellery Making,Jewellery Findings,y2k earrings stud,Earrings findings,emerald cut,bicolour tourmaline,Tourmaline Pairs,gift for her,Natural Stone,blue tourmaline lot,Oceangemsminerals,Clean Tourmaline. Had variations on Etsy — check size/options.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('6f10e7ab-c01e-4a84-b5d0-1298ce1ab252', '3 Cts Hexagon Tourmaline Pairs', 'Gorgeous Long Hexagon Cut Tourmaline Pairs

High Lustre And brilliance 

3 Cts
8.5 x 3.6 x 3mm
13.2 x 2.3 x 2mm

100% Natural No treatment whatsoever', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 356, 1, 'loose_stone', 'Tourmaline', NULL, 3, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/6f10e7ab-c01e-4a84-b5d0-1298ce1ab252/etsy-1.jpg","https://media.gemworkers.com/items/6f10e7ab-c01e-4a84-b5d0-1298ce1ab252/etsy-2.jpg","https://media.gemworkers.com/items/6f10e7ab-c01e-4a84-b5d0-1298ce1ab252/etsy-3.jpg","https://media.gemworkers.com/items/6f10e7ab-c01e-4a84-b5d0-1298ce1ab252/etsy-4.jpg","https://media.gemworkers.com/items/6f10e7ab-c01e-4a84-b5d0-1298ce1ab252/etsy-5.jpg","https://media.gemworkers.com/items/6f10e7ab-c01e-4a84-b5d0-1298ce1ab252/etsy-6.jpg","https://media.gemworkers.com/items/6f10e7ab-c01e-4a84-b5d0-1298ce1ab252/etsy-7.jpg","https://media.gemworkers.com/items/6f10e7ab-c01e-4a84-b5d0-1298ce1ab252/etsy-8.jpg","https://media.gemworkers.com/items/6f10e7ab-c01e-4a84-b5d0-1298ce1ab252/etsy-9.jpg","https://media.gemworkers.com/items/6f10e7ab-c01e-4a84-b5d0-1298ce1ab252/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 399 USD, converted at ECB rate. Etsy tags: Tourmaline Earrings,Jewellery Making,Jewellery Findings,y2k earrings stud,Earrings findings,emerald cut,bicolour tourmaline,Tourmaline Pairs,gift for her,Natural Stone,blue tourmaline lot,Oceangemsminerals,Clean Tourmaline. Had variations on Etsy — check size/options.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('0ce47536-5e38-4920-a694-1d14cb08c652', '4.90 Cts Unique Tricolour Tourmaline.', 'Gorgeous Mesmerising Tricolour Natural Afghanistan Tourmaline 

More beautiful In real, One of a kind

4.90 Cts
11 x 8.5 x 5mm

unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 219, 1, 'loose_stone', 'Tourmaline', NULL, 4.9, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/0ce47536-5e38-4920-a694-1d14cb08c652/etsy-1.jpg","https://media.gemworkers.com/items/0ce47536-5e38-4920-a694-1d14cb08c652/etsy-2.jpg","https://media.gemworkers.com/items/0ce47536-5e38-4920-a694-1d14cb08c652/etsy-3.jpg","https://media.gemworkers.com/items/0ce47536-5e38-4920-a694-1d14cb08c652/etsy-4.jpg","https://media.gemworkers.com/items/0ce47536-5e38-4920-a694-1d14cb08c652/etsy-5.jpg","https://media.gemworkers.com/items/0ce47536-5e38-4920-a694-1d14cb08c652/etsy-6.jpg","https://media.gemworkers.com/items/0ce47536-5e38-4920-a694-1d14cb08c652/etsy-7.jpg","https://media.gemworkers.com/items/0ce47536-5e38-4920-a694-1d14cb08c652/etsy-8.jpg","https://media.gemworkers.com/items/0ce47536-5e38-4920-a694-1d14cb08c652/etsy-9.jpg","https://media.gemworkers.com/items/0ce47536-5e38-4920-a694-1d14cb08c652/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 245 USD, converted at ECB rate. Etsy tags: Gold Rings,Rings For Men,Gift For Her,Tourmaline Jewellery,Natural Stone,Stud Earrings,Jewellery Stud,bicolour Tourmaline,Lagoon tourmaline,Tricolour Tourmaline,Oceangemsminerals,blue tourmaline,tourmaline pairs.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('ebf4f137-1835-4cc4-a926-30d62462ecf2', '10 Cts, hot pink bicolour tourmaline', 'gorgeous hor pink bicolour unique tourmaline 

Rare Find

10.00 Cts
13 x 11 x 8.5mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 178, 1, 'loose_stone', 'Tourmaline', NULL, 10, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/ebf4f137-1835-4cc4-a926-30d62462ecf2/etsy-1.jpg","https://media.gemworkers.com/items/ebf4f137-1835-4cc4-a926-30d62462ecf2/etsy-2.jpg","https://media.gemworkers.com/items/ebf4f137-1835-4cc4-a926-30d62462ecf2/etsy-3.jpg","https://media.gemworkers.com/items/ebf4f137-1835-4cc4-a926-30d62462ecf2/etsy-4.jpg","https://media.gemworkers.com/items/ebf4f137-1835-4cc4-a926-30d62462ecf2/etsy-5.jpg","https://media.gemworkers.com/items/ebf4f137-1835-4cc4-a926-30d62462ecf2/etsy-6.jpg","https://media.gemworkers.com/items/ebf4f137-1835-4cc4-a926-30d62462ecf2/etsy-7.jpg","https://media.gemworkers.com/items/ebf4f137-1835-4cc4-a926-30d62462ecf2/etsy-8.jpg","https://media.gemworkers.com/items/ebf4f137-1835-4cc4-a926-30d62462ecf2/etsy-9.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 199 USD, converted at ECB rate. Etsy tags: Jewellery Making,Jewellery Supplies,Rings For Women,Rings For Men,tourmaline jewellery,tourmaline rings,loose gemstones,natural stone,gold rings,pink tourmaline,Oceangemsminerals,Tourmaline Gemstones,Lagoon Tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('e57553a6-aae0-47ea-85be-b5163dda2bd5', '8.15 Cts Tricolour Tourmaline', 'Natural Rare Tricolour mesmerising tourmaline 

8.15 Cts
13.2 x 8.7 x 6.8mm

unheated, untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 491, 1, 'loose_stone', 'Tourmaline', NULL, 8.15, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/e57553a6-aae0-47ea-85be-b5163dda2bd5/etsy-1.jpg","https://media.gemworkers.com/items/e57553a6-aae0-47ea-85be-b5163dda2bd5/etsy-2.jpg","https://media.gemworkers.com/items/e57553a6-aae0-47ea-85be-b5163dda2bd5/etsy-3.jpg","https://media.gemworkers.com/items/e57553a6-aae0-47ea-85be-b5163dda2bd5/etsy-4.jpg","https://media.gemworkers.com/items/e57553a6-aae0-47ea-85be-b5163dda2bd5/etsy-5.jpg","https://media.gemworkers.com/items/e57553a6-aae0-47ea-85be-b5163dda2bd5/etsy-6.jpg","https://media.gemworkers.com/items/e57553a6-aae0-47ea-85be-b5163dda2bd5/etsy-7.jpg","https://media.gemworkers.com/items/e57553a6-aae0-47ea-85be-b5163dda2bd5/etsy-8.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 550 USD, converted at ECB rate. Etsy tags: Rings for women,natural stone,gift for her,jewellery making,jewellery supplies,jewellery findings,bicolour tourmaline,pink tourmaline,stud jewellery,tourmaline emerald,emerald cut,green tourmaline,Watermelon Tourmalin.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('610dbeca-09ef-4723-818f-2cef18995b41', '4.80 Cts Tricolour Tourmaline', 'Natural Rare Tricolour mesmerising tourmaline 

4.80 Cts
10.4 x 7.8 x 5.9mm

unheated, untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 429, 1, 'loose_stone', 'Tourmaline', NULL, 4.8, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/610dbeca-09ef-4723-818f-2cef18995b41/etsy-1.jpg","https://media.gemworkers.com/items/610dbeca-09ef-4723-818f-2cef18995b41/etsy-2.jpg","https://media.gemworkers.com/items/610dbeca-09ef-4723-818f-2cef18995b41/etsy-3.jpg","https://media.gemworkers.com/items/610dbeca-09ef-4723-818f-2cef18995b41/etsy-4.jpg","https://media.gemworkers.com/items/610dbeca-09ef-4723-818f-2cef18995b41/etsy-5.jpg","https://media.gemworkers.com/items/610dbeca-09ef-4723-818f-2cef18995b41/etsy-6.jpg","https://media.gemworkers.com/items/610dbeca-09ef-4723-818f-2cef18995b41/etsy-7.jpg","https://media.gemworkers.com/items/610dbeca-09ef-4723-818f-2cef18995b41/etsy-8.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 480 USD, converted at ECB rate. Etsy tags: Rings for women,natural stone,gift for her,jewellery making,jewellery supplies,jewellery findings,bicolour tourmaline,pink tourmaline,stud jewellery,tourmaline emerald,emerald cut,green tourmaline,Watermelon Tourmalin.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('a0eddadf-fe71-4654-bb65-b76b17f25886', '8.95 Cts Tricolour Tourmaline', 'Natural Rare Tricolour mesmerising tourmaline 

8.95 Cts
13.8 x 9 x 7.2mm

unheated, untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 447, 1, 'loose_stone', 'Tourmaline', NULL, 8.95, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/a0eddadf-fe71-4654-bb65-b76b17f25886/etsy-1.jpg","https://media.gemworkers.com/items/a0eddadf-fe71-4654-bb65-b76b17f25886/etsy-2.jpg","https://media.gemworkers.com/items/a0eddadf-fe71-4654-bb65-b76b17f25886/etsy-3.jpg","https://media.gemworkers.com/items/a0eddadf-fe71-4654-bb65-b76b17f25886/etsy-4.jpg","https://media.gemworkers.com/items/a0eddadf-fe71-4654-bb65-b76b17f25886/etsy-5.jpg","https://media.gemworkers.com/items/a0eddadf-fe71-4654-bb65-b76b17f25886/etsy-6.jpg","https://media.gemworkers.com/items/a0eddadf-fe71-4654-bb65-b76b17f25886/etsy-7.jpg","https://media.gemworkers.com/items/a0eddadf-fe71-4654-bb65-b76b17f25886/etsy-8.jpg","https://media.gemworkers.com/items/a0eddadf-fe71-4654-bb65-b76b17f25886/etsy-9.jpg","https://media.gemworkers.com/items/a0eddadf-fe71-4654-bb65-b76b17f25886/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 500 USD, converted at ECB rate. Etsy tags: Rings for women,natural stone,gift for her,jewellery making,jewellery supplies,jewellery findings,bicolour tourmaline,pink tourmaline,stud jewellery,tourmaline emerald,emerald cut,green tourmaline,Watermelon Tourmalin.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('153d186a-cdef-48c3-b581-32578c819aa0', '3.80 Cts Tricolour Tourmaline', 'Natural Rare Tricolour mesmerising tourmaline 

3.80 Cts
10 x 6.7 x 5.4mm

unheated, untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 429, 1, 'loose_stone', 'Tourmaline', NULL, 3.8, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/153d186a-cdef-48c3-b581-32578c819aa0/etsy-1.jpg","https://media.gemworkers.com/items/153d186a-cdef-48c3-b581-32578c819aa0/etsy-2.jpg","https://media.gemworkers.com/items/153d186a-cdef-48c3-b581-32578c819aa0/etsy-3.jpg","https://media.gemworkers.com/items/153d186a-cdef-48c3-b581-32578c819aa0/etsy-4.jpg","https://media.gemworkers.com/items/153d186a-cdef-48c3-b581-32578c819aa0/etsy-5.jpg","https://media.gemworkers.com/items/153d186a-cdef-48c3-b581-32578c819aa0/etsy-6.jpg","https://media.gemworkers.com/items/153d186a-cdef-48c3-b581-32578c819aa0/etsy-7.jpg","https://media.gemworkers.com/items/153d186a-cdef-48c3-b581-32578c819aa0/etsy-8.jpg","https://media.gemworkers.com/items/153d186a-cdef-48c3-b581-32578c819aa0/etsy-9.jpg","https://media.gemworkers.com/items/153d186a-cdef-48c3-b581-32578c819aa0/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 480 USD, converted at ECB rate. Etsy tags: Rings for women,natural stone,gift for her,jewellery making,jewellery supplies,jewellery findings,bicolour tourmaline,pink tourmaline,stud jewellery,tourmaline emerald,emerald cut,green tourmaline,Watermelon Tourmalin.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('75541464-6e10-44d6-9501-ad8ad1794560', '6.85 Cts Tricolour Tourmaline', 'Natural Rare Tricolour mesmerising tourmaline 

6.85 Cts
15.4 x 7.6 x 5.8mm

unheated, untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 357, 1, 'loose_stone', 'Tourmaline', NULL, 6.85, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/75541464-6e10-44d6-9501-ad8ad1794560/etsy-1.jpg","https://media.gemworkers.com/items/75541464-6e10-44d6-9501-ad8ad1794560/etsy-2.jpg","https://media.gemworkers.com/items/75541464-6e10-44d6-9501-ad8ad1794560/etsy-3.jpg","https://media.gemworkers.com/items/75541464-6e10-44d6-9501-ad8ad1794560/etsy-4.jpg","https://media.gemworkers.com/items/75541464-6e10-44d6-9501-ad8ad1794560/etsy-5.jpg","https://media.gemworkers.com/items/75541464-6e10-44d6-9501-ad8ad1794560/etsy-6.jpg","https://media.gemworkers.com/items/75541464-6e10-44d6-9501-ad8ad1794560/etsy-7.jpg","https://media.gemworkers.com/items/75541464-6e10-44d6-9501-ad8ad1794560/etsy-8.jpg","https://media.gemworkers.com/items/75541464-6e10-44d6-9501-ad8ad1794560/etsy-9.jpg","https://media.gemworkers.com/items/75541464-6e10-44d6-9501-ad8ad1794560/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 400 USD, converted at ECB rate. Etsy tags: Rings for women,natural stone,gift for her,jewellery making,jewellery supplies,jewellery findings,bicolour tourmaline,pink tourmaline,stud jewellery,tourmaline emerald,emerald cut,green tourmaline,Watermelon Tourmalin.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('45435740-cd59-432e-b832-d8548558123d', '8 Cts Lagoon and neon blue tourmaline lot', 'lagoon and neon blue colour tourmalines

top colour high lustre and brilliance 

8 Cts
6.9 to 4.5mm

100% natural no treatment whatsoever.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 356, 1, 'loose_stone', 'Tourmaline', NULL, 8, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/45435740-cd59-432e-b832-d8548558123d/etsy-1.jpg","https://media.gemworkers.com/items/45435740-cd59-432e-b832-d8548558123d/etsy-2.jpg","https://media.gemworkers.com/items/45435740-cd59-432e-b832-d8548558123d/etsy-3.jpg","https://media.gemworkers.com/items/45435740-cd59-432e-b832-d8548558123d/etsy-4.jpg","https://media.gemworkers.com/items/45435740-cd59-432e-b832-d8548558123d/etsy-5.jpg","https://media.gemworkers.com/items/45435740-cd59-432e-b832-d8548558123d/etsy-6.jpg","https://media.gemworkers.com/items/45435740-cd59-432e-b832-d8548558123d/etsy-7.jpg","https://media.gemworkers.com/items/45435740-cd59-432e-b832-d8548558123d/etsy-8.jpg","https://media.gemworkers.com/items/45435740-cd59-432e-b832-d8548558123d/etsy-9.jpg","https://media.gemworkers.com/items/45435740-cd59-432e-b832-d8548558123d/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 399 USD, converted at ECB rate. Etsy tags: Natural Stone,Jewellery Supplies,Jewellery Making,Jewellery Findings,y2k stud earrings,Gift For Her,Rings For Men,Rings For Women,Gold Rings,Silver Sterling,Garnet Necklace,Garnet Rings,Garnet Jewellery.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('dce79195-3cd2-4e94-bd77-c4a4830cca36', '8.65 Cts Spinel Lot From Burma', 'A Very Unique Spinel Lot

Top Quality 

Purplish Pink Colour

Bright And Brilliance 

8.65 Cts
7.4 to 5mm

Unheated, Untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 581, 1, 'loose_stone', 'Spinel', NULL, 8.65, 'ct', 'Myanmar', NULL, NULL, '["https://media.gemworkers.com/items/dce79195-3cd2-4e94-bd77-c4a4830cca36/etsy-1.jpg","https://media.gemworkers.com/items/dce79195-3cd2-4e94-bd77-c4a4830cca36/etsy-2.jpg","https://media.gemworkers.com/items/dce79195-3cd2-4e94-bd77-c4a4830cca36/etsy-3.jpg","https://media.gemworkers.com/items/dce79195-3cd2-4e94-bd77-c4a4830cca36/etsy-4.jpg","https://media.gemworkers.com/items/dce79195-3cd2-4e94-bd77-c4a4830cca36/etsy-5.jpg","https://media.gemworkers.com/items/dce79195-3cd2-4e94-bd77-c4a4830cca36/etsy-6.jpg","https://media.gemworkers.com/items/dce79195-3cd2-4e94-bd77-c4a4830cca36/etsy-7.jpg","https://media.gemworkers.com/items/dce79195-3cd2-4e94-bd77-c4a4830cca36/etsy-8.jpg","https://media.gemworkers.com/items/dce79195-3cd2-4e94-bd77-c4a4830cca36/etsy-9.jpg","https://media.gemworkers.com/items/dce79195-3cd2-4e94-bd77-c4a4830cca36/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 650 USD, converted at ECB rate. Etsy tags: Spinel Jewellery,Spinel Rings,Pink Spinel,Orange Spinel,Bicolour Spinel,Unique Spinel,Faceted Spinel,Jewellery Making,Jewellery Supplies,Oceangemsminerals,Spinel Necklace,Gift For Her,Natural Stone.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('d75363e9-d0bc-4f72-bd7d-bd54859e0e6b', '8.65 Cts Tricolour Tourmaline', 'Natural Rare Tricolour mesmerising tourmaline 

8.65 Cts
15.8 x 8 x 6.6mm

unheated, untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 357, 1, 'loose_stone', 'Tourmaline', NULL, 8.65, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/d75363e9-d0bc-4f72-bd7d-bd54859e0e6b/etsy-1.jpg","https://media.gemworkers.com/items/d75363e9-d0bc-4f72-bd7d-bd54859e0e6b/etsy-2.jpg","https://media.gemworkers.com/items/d75363e9-d0bc-4f72-bd7d-bd54859e0e6b/etsy-3.jpg","https://media.gemworkers.com/items/d75363e9-d0bc-4f72-bd7d-bd54859e0e6b/etsy-4.jpg","https://media.gemworkers.com/items/d75363e9-d0bc-4f72-bd7d-bd54859e0e6b/etsy-5.jpg","https://media.gemworkers.com/items/d75363e9-d0bc-4f72-bd7d-bd54859e0e6b/etsy-6.jpg","https://media.gemworkers.com/items/d75363e9-d0bc-4f72-bd7d-bd54859e0e6b/etsy-7.jpg","https://media.gemworkers.com/items/d75363e9-d0bc-4f72-bd7d-bd54859e0e6b/etsy-8.jpg","https://media.gemworkers.com/items/d75363e9-d0bc-4f72-bd7d-bd54859e0e6b/etsy-9.jpg","https://media.gemworkers.com/items/d75363e9-d0bc-4f72-bd7d-bd54859e0e6b/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 400 USD, converted at ECB rate. Etsy tags: Rings for women,natural stone,gift for her,jewellery making,jewellery supplies,jewellery findings,bicolour tourmaline,pink tourmaline,stud jewellery,tourmaline emerald,emerald cut,green tourmaline,Watermelon Tourmalin.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('71c53f58-1413-4766-a87c-c26b39b199f0', '6.40 Cts Tricolour Tourmaline', 'Natural Rare Tricolour mesmerising tourmaline 

6.40 Cts
14.7 x 8.5 x 5.4mm

unheated, untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 268, 1, 'loose_stone', 'Tourmaline', NULL, 6.4, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/71c53f58-1413-4766-a87c-c26b39b199f0/etsy-1.jpg","https://media.gemworkers.com/items/71c53f58-1413-4766-a87c-c26b39b199f0/etsy-2.jpg","https://media.gemworkers.com/items/71c53f58-1413-4766-a87c-c26b39b199f0/etsy-3.jpg","https://media.gemworkers.com/items/71c53f58-1413-4766-a87c-c26b39b199f0/etsy-4.jpg","https://media.gemworkers.com/items/71c53f58-1413-4766-a87c-c26b39b199f0/etsy-5.jpg","https://media.gemworkers.com/items/71c53f58-1413-4766-a87c-c26b39b199f0/etsy-6.jpg","https://media.gemworkers.com/items/71c53f58-1413-4766-a87c-c26b39b199f0/etsy-7.jpg","https://media.gemworkers.com/items/71c53f58-1413-4766-a87c-c26b39b199f0/etsy-8.jpg","https://media.gemworkers.com/items/71c53f58-1413-4766-a87c-c26b39b199f0/etsy-9.jpg","https://media.gemworkers.com/items/71c53f58-1413-4766-a87c-c26b39b199f0/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 300 USD, converted at ECB rate. Etsy tags: Rings for women,natural stone,gift for her,jewellery making,jewellery supplies,jewellery findings,bicolour tourmaline,pink tourmaline,stud jewellery,tourmaline emerald,emerald cut,green tourmaline,Watermelon Tourmalin.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('28bd1768-e64c-4c13-9c5a-b24fe9dfd9b9', '5 Cts Seafoam Tourmalines', 'Gorgeous Seafoam Tourmaline 

Best For Ring 

5 Cts
8.3 x 7.8 x 5.2mm
7.1 x 6.1 x 5mm
7 x 4.5 x 3mm

100% natural no treatment whatsoever.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 313, 1, 'loose_stone', 'Tourmaline', NULL, 5, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/28bd1768-e64c-4c13-9c5a-b24fe9dfd9b9/etsy-1.jpg","https://media.gemworkers.com/items/28bd1768-e64c-4c13-9c5a-b24fe9dfd9b9/etsy-2.jpg","https://media.gemworkers.com/items/28bd1768-e64c-4c13-9c5a-b24fe9dfd9b9/etsy-3.jpg","https://media.gemworkers.com/items/28bd1768-e64c-4c13-9c5a-b24fe9dfd9b9/etsy-4.jpg","https://media.gemworkers.com/items/28bd1768-e64c-4c13-9c5a-b24fe9dfd9b9/etsy-5.jpg","https://media.gemworkers.com/items/28bd1768-e64c-4c13-9c5a-b24fe9dfd9b9/etsy-6.jpg","https://media.gemworkers.com/items/28bd1768-e64c-4c13-9c5a-b24fe9dfd9b9/etsy-7.jpg","https://media.gemworkers.com/items/28bd1768-e64c-4c13-9c5a-b24fe9dfd9b9/etsy-8.jpg","https://media.gemworkers.com/items/28bd1768-e64c-4c13-9c5a-b24fe9dfd9b9/etsy-9.jpg","https://media.gemworkers.com/items/28bd1768-e64c-4c13-9c5a-b24fe9dfd9b9/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 350 USD, converted at ECB rate. Etsy tags: Rings for women,rings for men,Lagoon Tourmaline,Blue Tourmaline,Tiffany Colour,Tiffany Tourmaline,Loose gemstones,natural stone,Jewels,jewellery making,jewellery supplies,jewellery findings,Handmadejewellery.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('f7f80a1e-4f33-4f09-b20c-e835f6e98a52', '3.65 Cts Blue Green Tourmaline', 'Top Quality Blue Green Tourmaline 

Glossy And High Lustre

3.65 Cts
12.1 x 6.5 x 5.2mm

Unheated, No treatment Whatsoever.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 339, 1, 'loose_stone', 'Tourmaline', NULL, 3.65, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/f7f80a1e-4f33-4f09-b20c-e835f6e98a52/etsy-1.jpg","https://media.gemworkers.com/items/f7f80a1e-4f33-4f09-b20c-e835f6e98a52/etsy-2.jpg","https://media.gemworkers.com/items/f7f80a1e-4f33-4f09-b20c-e835f6e98a52/etsy-3.jpg","https://media.gemworkers.com/items/f7f80a1e-4f33-4f09-b20c-e835f6e98a52/etsy-4.jpg","https://media.gemworkers.com/items/f7f80a1e-4f33-4f09-b20c-e835f6e98a52/etsy-5.jpg","https://media.gemworkers.com/items/f7f80a1e-4f33-4f09-b20c-e835f6e98a52/etsy-6.jpg","https://media.gemworkers.com/items/f7f80a1e-4f33-4f09-b20c-e835f6e98a52/etsy-7.jpg","https://media.gemworkers.com/items/f7f80a1e-4f33-4f09-b20c-e835f6e98a52/etsy-8.jpg","https://media.gemworkers.com/items/f7f80a1e-4f33-4f09-b20c-e835f6e98a52/etsy-9.jpg","https://media.gemworkers.com/items/f7f80a1e-4f33-4f09-b20c-e835f6e98a52/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 380 USD, converted at ECB rate. Etsy tags: Jewellery Making,Rings For Women,Rings For Men,Gold Rings,Jewellery Supplies,Gift For Her,Natural Stone,Bluegreen Tourmaline,Blue tourmaline,lagoon Tourmaline,MintGreen Tourmaline,Oceangemsminerals,Green Tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('9a26b8e3-d185-4c7d-b051-694478b304fc', '9.25 Cts Bicolour Tourmaline pairs', 'unique combinations tourmaline pairs

Very Bright And Glowing Polish 

At very reasonable price 

Good size and lustre

9.25 Cts
7.3 x 6.7 x 4.8mm
6 x 4.8 x 4mm

Unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 223, 1, 'loose_stone', 'Tourmaline', NULL, 9.25, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/9a26b8e3-d185-4c7d-b051-694478b304fc/etsy-1.jpg","https://media.gemworkers.com/items/9a26b8e3-d185-4c7d-b051-694478b304fc/etsy-2.jpg","https://media.gemworkers.com/items/9a26b8e3-d185-4c7d-b051-694478b304fc/etsy-3.jpg","https://media.gemworkers.com/items/9a26b8e3-d185-4c7d-b051-694478b304fc/etsy-4.jpg","https://media.gemworkers.com/items/9a26b8e3-d185-4c7d-b051-694478b304fc/etsy-5.jpg","https://media.gemworkers.com/items/9a26b8e3-d185-4c7d-b051-694478b304fc/etsy-6.jpg","https://media.gemworkers.com/items/9a26b8e3-d185-4c7d-b051-694478b304fc/etsy-7.jpg","https://media.gemworkers.com/items/9a26b8e3-d185-4c7d-b051-694478b304fc/etsy-8.jpg","https://media.gemworkers.com/items/9a26b8e3-d185-4c7d-b051-694478b304fc/etsy-9.jpg","https://media.gemworkers.com/items/9a26b8e3-d185-4c7d-b051-694478b304fc/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 250 USD, converted at ECB rate. Etsy tags: Tricolour Tourmaline,Tourmaline Pairs,Tricolour Pairs,Unique Tourmaline,Unique Pairs,Blue Tricolour Pairs,Blue tourmaline pair,Lagoon Tourmaline,Neon Tourmaline,Rare Tourmaline,Rare Tricolour Pairs,Oceangemsminerals,Ink blue Tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('4b82eceb-8c2b-4c0e-ae0b-197434784f11', '9.25 Cts Bicolour Tourmaline pairs', 'unique combinations tourmaline pairs

Very Bright And Glowing Polish 

At very reasonable price 

Good size and lustre

9.25 Cts
7.3 x 6.6 x 4.9mm
6 x 4.7 x 3.7mm

Unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 223, 1, 'loose_stone', 'Tourmaline', NULL, 9.25, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/4b82eceb-8c2b-4c0e-ae0b-197434784f11/etsy-1.jpg","https://media.gemworkers.com/items/4b82eceb-8c2b-4c0e-ae0b-197434784f11/etsy-2.jpg","https://media.gemworkers.com/items/4b82eceb-8c2b-4c0e-ae0b-197434784f11/etsy-3.jpg","https://media.gemworkers.com/items/4b82eceb-8c2b-4c0e-ae0b-197434784f11/etsy-4.jpg","https://media.gemworkers.com/items/4b82eceb-8c2b-4c0e-ae0b-197434784f11/etsy-5.jpg","https://media.gemworkers.com/items/4b82eceb-8c2b-4c0e-ae0b-197434784f11/etsy-6.jpg","https://media.gemworkers.com/items/4b82eceb-8c2b-4c0e-ae0b-197434784f11/etsy-7.jpg","https://media.gemworkers.com/items/4b82eceb-8c2b-4c0e-ae0b-197434784f11/etsy-8.jpg","https://media.gemworkers.com/items/4b82eceb-8c2b-4c0e-ae0b-197434784f11/etsy-9.jpg","https://media.gemworkers.com/items/4b82eceb-8c2b-4c0e-ae0b-197434784f11/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 250 USD, converted at ECB rate. Etsy tags: Tricolour Tourmaline,Tourmaline Pairs,Tricolour Pairs,Unique Tourmaline,Unique Pairs,Blue Tricolour Pairs,Blue tourmaline pair,Lagoon Tourmaline,Neon Tourmaline,Rare Tourmaline,Rare Tricolour Pairs,Oceangemsminerals,Ink blue Tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('6e6c53ca-15c1-4c3a-9aab-cb12aed47ca4', '7.15 Cts Bicolour Tourmaline pairs', 'unique combinations tourmaline pair

Very Bright And Glowing Polish 

At very reasonable price 

Good size and lustre

7.15 cts
8 x 5.2 x 3.5mm
5.9 x 5 x 3.8mm

Unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 223, 1, 'loose_stone', 'Tourmaline', NULL, 7.15, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/6e6c53ca-15c1-4c3a-9aab-cb12aed47ca4/etsy-1.jpg","https://media.gemworkers.com/items/6e6c53ca-15c1-4c3a-9aab-cb12aed47ca4/etsy-2.jpg","https://media.gemworkers.com/items/6e6c53ca-15c1-4c3a-9aab-cb12aed47ca4/etsy-3.jpg","https://media.gemworkers.com/items/6e6c53ca-15c1-4c3a-9aab-cb12aed47ca4/etsy-4.jpg","https://media.gemworkers.com/items/6e6c53ca-15c1-4c3a-9aab-cb12aed47ca4/etsy-5.jpg","https://media.gemworkers.com/items/6e6c53ca-15c1-4c3a-9aab-cb12aed47ca4/etsy-6.jpg","https://media.gemworkers.com/items/6e6c53ca-15c1-4c3a-9aab-cb12aed47ca4/etsy-7.jpg","https://media.gemworkers.com/items/6e6c53ca-15c1-4c3a-9aab-cb12aed47ca4/etsy-8.jpg","https://media.gemworkers.com/items/6e6c53ca-15c1-4c3a-9aab-cb12aed47ca4/etsy-9.jpg","https://media.gemworkers.com/items/6e6c53ca-15c1-4c3a-9aab-cb12aed47ca4/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 250 USD, converted at ECB rate. Etsy tags: Tricolour Tourmaline,Tourmaline Pairs,Tricolour Pairs,Unique Tourmaline,Unique Pairs,Blue Tricolour Pairs,Blue tourmaline pair,Lagoon Tourmaline,Neon Tourmaline,Rare Tourmaline,Rare Tricolour Pairs,Oceangemsminerals,Ink blue Tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('0465e879-3d1d-4da1-adab-5527c0a70045', '5.50 Cts Tricolour Tourmaline', 'Natural Rare Tricolour mesmerising tourmaline 

5.50 Cts
14.4 x 8.3 x 5mm

unheated, untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 255, 1, 'loose_stone', 'Tourmaline', NULL, 5.5, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/0465e879-3d1d-4da1-adab-5527c0a70045/etsy-1.jpg","https://media.gemworkers.com/items/0465e879-3d1d-4da1-adab-5527c0a70045/etsy-2.jpg","https://media.gemworkers.com/items/0465e879-3d1d-4da1-adab-5527c0a70045/etsy-3.jpg","https://media.gemworkers.com/items/0465e879-3d1d-4da1-adab-5527c0a70045/etsy-4.jpg","https://media.gemworkers.com/items/0465e879-3d1d-4da1-adab-5527c0a70045/etsy-5.jpg","https://media.gemworkers.com/items/0465e879-3d1d-4da1-adab-5527c0a70045/etsy-6.jpg","https://media.gemworkers.com/items/0465e879-3d1d-4da1-adab-5527c0a70045/etsy-7.jpg","https://media.gemworkers.com/items/0465e879-3d1d-4da1-adab-5527c0a70045/etsy-8.jpg","https://media.gemworkers.com/items/0465e879-3d1d-4da1-adab-5527c0a70045/etsy-9.jpg","https://media.gemworkers.com/items/0465e879-3d1d-4da1-adab-5527c0a70045/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 285 USD, converted at ECB rate. Etsy tags: Rings for women,natural stone,gift for her,jewellery making,jewellery supplies,jewellery findings,bicolour tourmaline,pink tourmaline,stud jewellery,tourmaline emerald,emerald cut,green tourmaline,Watermelon Tourmalin.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('bd635c68-90b0-4c1a-8d19-deaf810360a5', '20 Cts Golden Citrine', 'Top Quality Citrine Golden Colour 

Excellent Cut, High Lustre

20 Cts
21.8 x 15.8 x 11mm

no treatment.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 268, 1, 'loose_stone', 'Quartz', 'Citrine', 20, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/bd635c68-90b0-4c1a-8d19-deaf810360a5/etsy-1.jpg","https://media.gemworkers.com/items/bd635c68-90b0-4c1a-8d19-deaf810360a5/etsy-2.jpg","https://media.gemworkers.com/items/bd635c68-90b0-4c1a-8d19-deaf810360a5/etsy-3.jpg","https://media.gemworkers.com/items/bd635c68-90b0-4c1a-8d19-deaf810360a5/etsy-4.jpg","https://media.gemworkers.com/items/bd635c68-90b0-4c1a-8d19-deaf810360a5/etsy-5.jpg","https://media.gemworkers.com/items/bd635c68-90b0-4c1a-8d19-deaf810360a5/etsy-6.jpg","https://media.gemworkers.com/items/bd635c68-90b0-4c1a-8d19-deaf810360a5/etsy-7.jpg","https://media.gemworkers.com/items/bd635c68-90b0-4c1a-8d19-deaf810360a5/etsy-8.jpg","https://media.gemworkers.com/items/bd635c68-90b0-4c1a-8d19-deaf810360a5/etsy-9.jpg","https://media.gemworkers.com/items/bd635c68-90b0-4c1a-8d19-deaf810360a5/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 300 USD, converted at ECB rate. Etsy tags: Rings For Women,Natural Stone,Handmade,Jewellery making,jewellery supplies,jewellery findings,Gift for her,Gold Rings,stud jewellery,rings for men,citrine set,jewellery set,citrine jewellery.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('adba8465-6da4-4cfa-a7ff-c4659dec586d', '3.35 Cts Tricolour Tourmaline', 'Natural Rare Tricolour mesmerising tourmaline 

3.55 Cts
14.5 x 6 x 3.9mm

unheated, untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 268, 1, 'loose_stone', 'Tourmaline', NULL, 3.35, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/adba8465-6da4-4cfa-a7ff-c4659dec586d/etsy-1.jpg","https://media.gemworkers.com/items/adba8465-6da4-4cfa-a7ff-c4659dec586d/etsy-2.jpg","https://media.gemworkers.com/items/adba8465-6da4-4cfa-a7ff-c4659dec586d/etsy-3.jpg","https://media.gemworkers.com/items/adba8465-6da4-4cfa-a7ff-c4659dec586d/etsy-4.jpg","https://media.gemworkers.com/items/adba8465-6da4-4cfa-a7ff-c4659dec586d/etsy-5.jpg","https://media.gemworkers.com/items/adba8465-6da4-4cfa-a7ff-c4659dec586d/etsy-6.jpg","https://media.gemworkers.com/items/adba8465-6da4-4cfa-a7ff-c4659dec586d/etsy-7.jpg","https://media.gemworkers.com/items/adba8465-6da4-4cfa-a7ff-c4659dec586d/etsy-8.jpg","https://media.gemworkers.com/items/adba8465-6da4-4cfa-a7ff-c4659dec586d/etsy-9.jpg","https://media.gemworkers.com/items/adba8465-6da4-4cfa-a7ff-c4659dec586d/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 300 USD, converted at ECB rate. Etsy tags: Rings for women,natural stone,gift for her,jewellery making,jewellery supplies,jewellery findings,bicolour tourmaline,pink tourmaline,stud jewellery,tourmaline emerald,emerald cut,green tourmaline,Watermelon Tourmalin.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('6944ca97-e5aa-49fc-9531-e21af4f01c5a', '6.65 Cts Tricolour Tourmaline', 'Natural Rare Tricolour mesmerising tourmaline 

6.65 Cts
15 x 7.2 x 5.9mm

unheated, untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 268, 1, 'loose_stone', 'Tourmaline', NULL, 6.65, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/6944ca97-e5aa-49fc-9531-e21af4f01c5a/etsy-1.jpg","https://media.gemworkers.com/items/6944ca97-e5aa-49fc-9531-e21af4f01c5a/etsy-2.jpg","https://media.gemworkers.com/items/6944ca97-e5aa-49fc-9531-e21af4f01c5a/etsy-3.jpg","https://media.gemworkers.com/items/6944ca97-e5aa-49fc-9531-e21af4f01c5a/etsy-4.jpg","https://media.gemworkers.com/items/6944ca97-e5aa-49fc-9531-e21af4f01c5a/etsy-5.jpg","https://media.gemworkers.com/items/6944ca97-e5aa-49fc-9531-e21af4f01c5a/etsy-6.jpg","https://media.gemworkers.com/items/6944ca97-e5aa-49fc-9531-e21af4f01c5a/etsy-7.jpg","https://media.gemworkers.com/items/6944ca97-e5aa-49fc-9531-e21af4f01c5a/etsy-8.jpg","https://media.gemworkers.com/items/6944ca97-e5aa-49fc-9531-e21af4f01c5a/etsy-9.jpg","https://media.gemworkers.com/items/6944ca97-e5aa-49fc-9531-e21af4f01c5a/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 300 USD, converted at ECB rate. Etsy tags: Rings for women,natural stone,gift for her,jewellery making,jewellery supplies,jewellery findings,bicolour tourmaline,pink tourmaline,stud jewellery,tourmaline emerald,emerald cut,green tourmaline,Watermelon Tourmalin.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('307c32cb-928d-4412-ab19-5eabcc940072', '5 Cts Tricolour Tourmaline', 'Natural Rare Tricolour mesmerising tourmaline 

5.00 Cts
14.6 x 7.6 x 4.6mm

unheated, untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 223, 1, 'loose_stone', 'Tourmaline', NULL, 5, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/307c32cb-928d-4412-ab19-5eabcc940072/etsy-1.jpg","https://media.gemworkers.com/items/307c32cb-928d-4412-ab19-5eabcc940072/etsy-2.jpg","https://media.gemworkers.com/items/307c32cb-928d-4412-ab19-5eabcc940072/etsy-3.jpg","https://media.gemworkers.com/items/307c32cb-928d-4412-ab19-5eabcc940072/etsy-4.jpg","https://media.gemworkers.com/items/307c32cb-928d-4412-ab19-5eabcc940072/etsy-5.jpg","https://media.gemworkers.com/items/307c32cb-928d-4412-ab19-5eabcc940072/etsy-6.jpg","https://media.gemworkers.com/items/307c32cb-928d-4412-ab19-5eabcc940072/etsy-7.jpg","https://media.gemworkers.com/items/307c32cb-928d-4412-ab19-5eabcc940072/etsy-8.jpg","https://media.gemworkers.com/items/307c32cb-928d-4412-ab19-5eabcc940072/etsy-9.jpg","https://media.gemworkers.com/items/307c32cb-928d-4412-ab19-5eabcc940072/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 250 USD, converted at ECB rate. Etsy tags: Rings for women,natural stone,gift for her,jewellery making,jewellery supplies,jewellery findings,bicolour tourmaline,pink tourmaline,stud jewellery,tourmaline emerald,emerald cut,green tourmaline,Watermelon Tourmalin.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('fe52f7e2-5357-42f1-ac80-54adb300bdd5', '3 Cts Tricolour Tourmaline', 'Natural Rare Tricolour mesmerising tourmaline 

3.00 Cts
15.2 x 4.8 x 3.9mm

unheated,', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 264, 1, 'loose_stone', 'Tourmaline', NULL, 3, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/fe52f7e2-5357-42f1-ac80-54adb300bdd5/etsy-1.jpg","https://media.gemworkers.com/items/fe52f7e2-5357-42f1-ac80-54adb300bdd5/etsy-2.jpg","https://media.gemworkers.com/items/fe52f7e2-5357-42f1-ac80-54adb300bdd5/etsy-3.jpg","https://media.gemworkers.com/items/fe52f7e2-5357-42f1-ac80-54adb300bdd5/etsy-4.jpg","https://media.gemworkers.com/items/fe52f7e2-5357-42f1-ac80-54adb300bdd5/etsy-5.jpg","https://media.gemworkers.com/items/fe52f7e2-5357-42f1-ac80-54adb300bdd5/etsy-6.jpg","https://media.gemworkers.com/items/fe52f7e2-5357-42f1-ac80-54adb300bdd5/etsy-7.jpg","https://media.gemworkers.com/items/fe52f7e2-5357-42f1-ac80-54adb300bdd5/etsy-8.jpg","https://media.gemworkers.com/items/fe52f7e2-5357-42f1-ac80-54adb300bdd5/etsy-9.jpg","https://media.gemworkers.com/items/fe52f7e2-5357-42f1-ac80-54adb300bdd5/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 295 USD, converted at ECB rate. Etsy tags: Rings for women,natural stone,gift for her,jewellery making,jewellery supplies,jewellery findings,bicolour tourmaline,pink tourmaline,stud jewellery,tourmaline emerald,emerald cut,green tourmaline,Watermelon Tourmalin.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
COMMIT;
