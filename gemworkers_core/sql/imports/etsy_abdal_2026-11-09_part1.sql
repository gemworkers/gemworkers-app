-- Abdal Shop Etsy import, PART 1 of 3 (250 drafts, unlisted; USD→EUR at ECB 1.1193). Run parts in order. Safe to run twice.
BEGIN;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('8c9eff24-e296-43eb-9d28-81dc4d7c09e2', '6.3 Cts Blue Green Tourmaline', 'Gorgeous Mesmerising Blue Green Afghan Tourmaline 

Unique Colour 

6.30 cts

Size:13.4x9.7x5.8mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 563, 1, 'loose_stone', 'Tourmaline', NULL, 6.3, 'ct', 'Afghanistan', NULL, '13.4x9.7x5.8', '["https://media.gemworkers.com/items/8c9eff24-e296-43eb-9d28-81dc4d7c09e2/etsy-1.jpg","https://media.gemworkers.com/items/8c9eff24-e296-43eb-9d28-81dc4d7c09e2/etsy-2.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 630 USD, converted at ECB rate. Etsy tags: BlueGreen Tourmaline,Blue Tourmaline,Green Tourmaline,Lagoon Tourmaline,Neon Tourmaline,Tourmaline Rings,rings for women,rings for men,jewellery making,jewellery supplies,jewellery findings,gift for her,natural stone.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('31d084cc-5a92-444f-b554-3dab280a8591', '1.9 Cts Lagoon Tourmaline', 'lagoon colour tourmaline

top colour high lustre and brilliance 

Paraiba Like Colour

1.90 cts

Size:7.4x7x4.7mm

100% natural no treatment whatsoever.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 356, 1, 'loose_stone', 'Tourmaline', NULL, 1.9, 'ct', NULL, NULL, '7.4x7x4.7', '["https://media.gemworkers.com/items/31d084cc-5a92-444f-b554-3dab280a8591/etsy-1.jpg","https://media.gemworkers.com/items/31d084cc-5a92-444f-b554-3dab280a8591/etsy-2.jpg","https://media.gemworkers.com/items/31d084cc-5a92-444f-b554-3dab280a8591/etsy-3.jpg","https://media.gemworkers.com/items/31d084cc-5a92-444f-b554-3dab280a8591/etsy-4.jpg","https://media.gemworkers.com/items/31d084cc-5a92-444f-b554-3dab280a8591/etsy-5.jpg","https://media.gemworkers.com/items/31d084cc-5a92-444f-b554-3dab280a8591/etsy-6.jpg","https://media.gemworkers.com/items/31d084cc-5a92-444f-b554-3dab280a8591/etsy-7.jpg","https://media.gemworkers.com/items/31d084cc-5a92-444f-b554-3dab280a8591/etsy-8.jpg","https://media.gemworkers.com/items/31d084cc-5a92-444f-b554-3dab280a8591/etsy-9.jpg","https://media.gemworkers.com/items/31d084cc-5a92-444f-b554-3dab280a8591/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 399 USD, converted at ECB rate. Etsy tags: Natural Stone,Jewellery Supplies,Jewellery Making,Jewellery Findings,y2k stud earrings,Gift For Her,Rings For Men,Rings For Women,Gold Rings,Silver Sterling,Garnet Necklace,Garnet Rings,Garnet Jewellery.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('54062379-9498-4a12-aed2-1305d88b4841', '3.9 Cts Blue Green Tourmaline', 'Gorgeous Mesmerising Blue Green Afghan Tourmaline 

Unique Colour 

3.90 cts

Size:9.6x8.7x6mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 446, 1, 'loose_stone', 'Tourmaline', NULL, 3.9, 'ct', 'Afghanistan', NULL, '9.6x8.7x6', '["https://media.gemworkers.com/items/54062379-9498-4a12-aed2-1305d88b4841/etsy-1.jpg","https://media.gemworkers.com/items/54062379-9498-4a12-aed2-1305d88b4841/etsy-2.jpg","https://media.gemworkers.com/items/54062379-9498-4a12-aed2-1305d88b4841/etsy-3.jpg","https://media.gemworkers.com/items/54062379-9498-4a12-aed2-1305d88b4841/etsy-4.jpg","https://media.gemworkers.com/items/54062379-9498-4a12-aed2-1305d88b4841/etsy-5.jpg","https://media.gemworkers.com/items/54062379-9498-4a12-aed2-1305d88b4841/etsy-6.jpg","https://media.gemworkers.com/items/54062379-9498-4a12-aed2-1305d88b4841/etsy-7.jpg","https://media.gemworkers.com/items/54062379-9498-4a12-aed2-1305d88b4841/etsy-8.jpg","https://media.gemworkers.com/items/54062379-9498-4a12-aed2-1305d88b4841/etsy-9.jpg","https://media.gemworkers.com/items/54062379-9498-4a12-aed2-1305d88b4841/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 499 USD, converted at ECB rate. Etsy tags: BlueGreen Tourmaline,Blue Tourmaline,Green Tourmaline,Lagoon Tourmaline,Neon Tourmaline,Tourmaline Rings,rings for women,rings for men,jewellery making,jewellery supplies,jewellery findings,gift for her,natural stone.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('ea1ebdcd-cce3-47dc-bb8d-13dc868f103a', '3 Cts Lagoon Tourmaline', 'lagoon colour tourmaline

top colour high lustre and brilliance 

Paraiba Like Colour

3 cts

Size:8.7x7.6x5.7mm

100% natural no treatment whatsoever.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 312, 1, 'loose_stone', 'Tourmaline', NULL, 3, 'ct', NULL, NULL, '8.7x7.6x5.7', '["https://media.gemworkers.com/items/ea1ebdcd-cce3-47dc-bb8d-13dc868f103a/etsy-1.jpg","https://media.gemworkers.com/items/ea1ebdcd-cce3-47dc-bb8d-13dc868f103a/etsy-2.jpg","https://media.gemworkers.com/items/ea1ebdcd-cce3-47dc-bb8d-13dc868f103a/etsy-3.jpg","https://media.gemworkers.com/items/ea1ebdcd-cce3-47dc-bb8d-13dc868f103a/etsy-4.jpg","https://media.gemworkers.com/items/ea1ebdcd-cce3-47dc-bb8d-13dc868f103a/etsy-5.jpg","https://media.gemworkers.com/items/ea1ebdcd-cce3-47dc-bb8d-13dc868f103a/etsy-6.jpg","https://media.gemworkers.com/items/ea1ebdcd-cce3-47dc-bb8d-13dc868f103a/etsy-7.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 349 USD, converted at ECB rate. Etsy tags: Natural Stone,Jewellery Supplies,Jewellery Making,Jewellery Findings,y2k stud earrings,Gift For Her,Rings For Men,Rings For Women,Gold Rings,Silver Sterling,Garnet Necklace,Garnet Rings,Garnet Jewellery.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('91c7a220-c5aa-40b3-9a96-20af1424fd67', '2.20 Cts Lagoon Green Tourmaline', 'Gorgeous Mesmerising Lagoon Green Afghan Tourmaline 

Unique Colour 

2.20 cts

Size:9.1x6.6x4.3mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 356, 1, 'loose_stone', 'Tourmaline', NULL, 2.2, 'ct', 'Afghanistan', NULL, '9.1x6.6x4.3', '["https://media.gemworkers.com/items/91c7a220-c5aa-40b3-9a96-20af1424fd67/etsy-1.jpg","https://media.gemworkers.com/items/91c7a220-c5aa-40b3-9a96-20af1424fd67/etsy-2.jpg","https://media.gemworkers.com/items/91c7a220-c5aa-40b3-9a96-20af1424fd67/etsy-3.jpg","https://media.gemworkers.com/items/91c7a220-c5aa-40b3-9a96-20af1424fd67/etsy-4.jpg","https://media.gemworkers.com/items/91c7a220-c5aa-40b3-9a96-20af1424fd67/etsy-5.jpg","https://media.gemworkers.com/items/91c7a220-c5aa-40b3-9a96-20af1424fd67/etsy-6.jpg","https://media.gemworkers.com/items/91c7a220-c5aa-40b3-9a96-20af1424fd67/etsy-7.jpg","https://media.gemworkers.com/items/91c7a220-c5aa-40b3-9a96-20af1424fd67/etsy-8.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 399 USD, converted at ECB rate. Etsy tags: BlueGreen Tourmaline,Blue Tourmaline,Green Tourmaline,Lagoon Tourmaline,Neon Tourmaline,Tourmaline Rings,rings for women,rings for men,jewellery making,jewellery supplies,jewellery findings,gift for her,natural stone.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('3a65c258-704f-4c0f-93c3-71ce6628168e', '1.7 Cts Lagoon Tourmaline', 'lagoon colour tourmaline

top colour high lustre and brilliance 

Paraiba Like Colour

1.70 cts

Size:7.3x7.5x4.7mm

100% natural no treatment whatsoever.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 446, 1, 'loose_stone', 'Tourmaline', NULL, 1.7, 'ct', NULL, NULL, '7.3x7.5x4.7', '["https://media.gemworkers.com/items/3a65c258-704f-4c0f-93c3-71ce6628168e/etsy-1.jpg","https://media.gemworkers.com/items/3a65c258-704f-4c0f-93c3-71ce6628168e/etsy-2.jpg","https://media.gemworkers.com/items/3a65c258-704f-4c0f-93c3-71ce6628168e/etsy-3.jpg","https://media.gemworkers.com/items/3a65c258-704f-4c0f-93c3-71ce6628168e/etsy-4.jpg","https://media.gemworkers.com/items/3a65c258-704f-4c0f-93c3-71ce6628168e/etsy-5.jpg","https://media.gemworkers.com/items/3a65c258-704f-4c0f-93c3-71ce6628168e/etsy-6.jpg","https://media.gemworkers.com/items/3a65c258-704f-4c0f-93c3-71ce6628168e/etsy-7.jpg","https://media.gemworkers.com/items/3a65c258-704f-4c0f-93c3-71ce6628168e/etsy-8.jpg","https://media.gemworkers.com/items/3a65c258-704f-4c0f-93c3-71ce6628168e/etsy-9.jpg","https://media.gemworkers.com/items/3a65c258-704f-4c0f-93c3-71ce6628168e/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 499 USD, converted at ECB rate. Etsy tags: Natural Stone,Jewellery Supplies,Jewellery Making,Jewellery Findings,y2k stud earrings,Gift For Her,Rings For Men,Rings For Women,Gold Rings,Silver Sterling,Garnet Necklace,Garnet Rings,Garnet Jewellery.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('16ae9c51-a022-45c2-8d96-a57d38b08115', '2.45 Cts Lagoon Green Tourmaline', 'Gorgeous Mesmerising Lagoon Green Afghan Tourmaline 

Unique Colour 

2.45 cts 

Size:8.5x6.7x5mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 446, 1, 'loose_stone', 'Tourmaline', NULL, 2.45, 'ct', 'Afghanistan', NULL, '8.5x6.7x5', '["https://media.gemworkers.com/items/16ae9c51-a022-45c2-8d96-a57d38b08115/etsy-1.jpg","https://media.gemworkers.com/items/16ae9c51-a022-45c2-8d96-a57d38b08115/etsy-2.jpg","https://media.gemworkers.com/items/16ae9c51-a022-45c2-8d96-a57d38b08115/etsy-3.jpg","https://media.gemworkers.com/items/16ae9c51-a022-45c2-8d96-a57d38b08115/etsy-4.jpg","https://media.gemworkers.com/items/16ae9c51-a022-45c2-8d96-a57d38b08115/etsy-5.jpg","https://media.gemworkers.com/items/16ae9c51-a022-45c2-8d96-a57d38b08115/etsy-6.jpg","https://media.gemworkers.com/items/16ae9c51-a022-45c2-8d96-a57d38b08115/etsy-7.jpg","https://media.gemworkers.com/items/16ae9c51-a022-45c2-8d96-a57d38b08115/etsy-8.jpg","https://media.gemworkers.com/items/16ae9c51-a022-45c2-8d96-a57d38b08115/etsy-9.jpg","https://media.gemworkers.com/items/16ae9c51-a022-45c2-8d96-a57d38b08115/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 499 USD, converted at ECB rate. Etsy tags: BlueGreen Tourmaline,Blue Tourmaline,Green Tourmaline,Lagoon Tourmaline,Neon Tourmaline,Tourmaline Rings,rings for women,rings for men,jewellery making,jewellery supplies,jewellery findings,gift for her,natural stone.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('f6db34fb-812c-4f55-b20d-e23adb0ab9c1', '1.4 Cts Lagoon Green Tourmaline', 'Gorgeous Mesmerising Lagoon Green Afghan Tourmaline 

Unique Colour 

1.40 cts

Size:6.7x6.5x4.2mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 267, 1, 'loose_stone', 'Tourmaline', NULL, 1.4, 'ct', 'Afghanistan', NULL, '6.7x6.5x4.2', '["https://media.gemworkers.com/items/f6db34fb-812c-4f55-b20d-e23adb0ab9c1/etsy-1.jpg","https://media.gemworkers.com/items/f6db34fb-812c-4f55-b20d-e23adb0ab9c1/etsy-2.jpg","https://media.gemworkers.com/items/f6db34fb-812c-4f55-b20d-e23adb0ab9c1/etsy-3.jpg","https://media.gemworkers.com/items/f6db34fb-812c-4f55-b20d-e23adb0ab9c1/etsy-4.jpg","https://media.gemworkers.com/items/f6db34fb-812c-4f55-b20d-e23adb0ab9c1/etsy-5.jpg","https://media.gemworkers.com/items/f6db34fb-812c-4f55-b20d-e23adb0ab9c1/etsy-6.jpg","https://media.gemworkers.com/items/f6db34fb-812c-4f55-b20d-e23adb0ab9c1/etsy-7.jpg","https://media.gemworkers.com/items/f6db34fb-812c-4f55-b20d-e23adb0ab9c1/etsy-8.jpg","https://media.gemworkers.com/items/f6db34fb-812c-4f55-b20d-e23adb0ab9c1/etsy-9.jpg","https://media.gemworkers.com/items/f6db34fb-812c-4f55-b20d-e23adb0ab9c1/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 299 USD, converted at ECB rate. Etsy tags: BlueGreen Tourmaline,Blue Tourmaline,Green Tourmaline,Lagoon Tourmaline,Neon Tourmaline,Tourmaline Rings,rings for women,rings for men,jewellery making,jewellery supplies,jewellery findings,gift for her,natural stone.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('1f021e7c-67ac-4b80-b419-887e81ea1eaf', '2.3 Cts Blue Green Tourmaline', 'Gorgeous Mesmerising Blue Green Afghan Tourmaline 

Unique Colour 

2.30 cts

Size:7.6x7.1x5.3mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 268, 1, 'loose_stone', 'Tourmaline', NULL, 2.3, 'ct', 'Afghanistan', NULL, '7.6x7.1x5.3', '["https://media.gemworkers.com/items/1f021e7c-67ac-4b80-b419-887e81ea1eaf/etsy-1.jpg","https://media.gemworkers.com/items/1f021e7c-67ac-4b80-b419-887e81ea1eaf/etsy-2.jpg","https://media.gemworkers.com/items/1f021e7c-67ac-4b80-b419-887e81ea1eaf/etsy-3.jpg","https://media.gemworkers.com/items/1f021e7c-67ac-4b80-b419-887e81ea1eaf/etsy-4.jpg","https://media.gemworkers.com/items/1f021e7c-67ac-4b80-b419-887e81ea1eaf/etsy-5.jpg","https://media.gemworkers.com/items/1f021e7c-67ac-4b80-b419-887e81ea1eaf/etsy-6.jpg","https://media.gemworkers.com/items/1f021e7c-67ac-4b80-b419-887e81ea1eaf/etsy-7.jpg","https://media.gemworkers.com/items/1f021e7c-67ac-4b80-b419-887e81ea1eaf/etsy-8.jpg","https://media.gemworkers.com/items/1f021e7c-67ac-4b80-b419-887e81ea1eaf/etsy-9.jpg","https://media.gemworkers.com/items/1f021e7c-67ac-4b80-b419-887e81ea1eaf/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 300 USD, converted at ECB rate. Etsy tags: BlueGreen Tourmaline,Blue Tourmaline,Green Tourmaline,Lagoon Tourmaline,Neon Tourmaline,Tourmaline Rings,rings for women,rings for men,jewellery making,jewellery supplies,jewellery findings,gift for her,natural stone.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('501e78bc-e8eb-4a16-a1bc-f14ad49bb037', '1.80 Cts Lagoon Tourmaline', 'Presenting One Of The Best Colour In Tourmalines

Exceptional Colour Very Rare To Be Find, Bright Colour Not Dull.

More Beautiful In Real. 

1.80 cts 

Size:6.6x6.3x5.1mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 160, 1, 'loose_stone', 'Tourmaline', NULL, 1.8, 'ct', NULL, NULL, '6.6x6.3x5.1', '["https://media.gemworkers.com/items/501e78bc-e8eb-4a16-a1bc-f14ad49bb037/etsy-1.jpg","https://media.gemworkers.com/items/501e78bc-e8eb-4a16-a1bc-f14ad49bb037/etsy-2.jpg","https://media.gemworkers.com/items/501e78bc-e8eb-4a16-a1bc-f14ad49bb037/etsy-3.jpg","https://media.gemworkers.com/items/501e78bc-e8eb-4a16-a1bc-f14ad49bb037/etsy-4.jpg","https://media.gemworkers.com/items/501e78bc-e8eb-4a16-a1bc-f14ad49bb037/etsy-5.jpg","https://media.gemworkers.com/items/501e78bc-e8eb-4a16-a1bc-f14ad49bb037/etsy-6.jpg","https://media.gemworkers.com/items/501e78bc-e8eb-4a16-a1bc-f14ad49bb037/etsy-7.jpg","https://media.gemworkers.com/items/501e78bc-e8eb-4a16-a1bc-f14ad49bb037/etsy-8.jpg","https://media.gemworkers.com/items/501e78bc-e8eb-4a16-a1bc-f14ad49bb037/etsy-9.jpg","https://media.gemworkers.com/items/501e78bc-e8eb-4a16-a1bc-f14ad49bb037/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 179 USD, converted at ECB rate. Etsy tags: Paraiba Tourmaline,Paraiba Colour,Lagoon Tourmaline,Bluegreen Tourmaline,Blue Tourmaline,Neon Blue Tourmaline,Tourmaline Jewellery,Jewellers,Lagoon Colour,Oceangemsminerals,Ink Blue Tourmaline,Wedding Rings,Rings For Women.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('c4817989-6a07-4afe-a3af-f1f817f2b0b4', '4.3 Cts Lagoon Tourmaline', 'Gorgeous Mesmerising Rare Blue Colour Afghan Tourmaline 

4.30 carat 

Size:9.5x8.5x6.4mm

unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 178, 1, 'loose_stone', 'Tourmaline', NULL, 4.3, 'ct', 'Afghanistan', NULL, '9.5x8.5x6.4', '["https://media.gemworkers.com/items/c4817989-6a07-4afe-a3af-f1f817f2b0b4/etsy-1.jpg","https://media.gemworkers.com/items/c4817989-6a07-4afe-a3af-f1f817f2b0b4/etsy-2.jpg","https://media.gemworkers.com/items/c4817989-6a07-4afe-a3af-f1f817f2b0b4/etsy-3.jpg","https://media.gemworkers.com/items/c4817989-6a07-4afe-a3af-f1f817f2b0b4/etsy-4.jpg","https://media.gemworkers.com/items/c4817989-6a07-4afe-a3af-f1f817f2b0b4/etsy-5.jpg","https://media.gemworkers.com/items/c4817989-6a07-4afe-a3af-f1f817f2b0b4/etsy-6.jpg","https://media.gemworkers.com/items/c4817989-6a07-4afe-a3af-f1f817f2b0b4/etsy-7.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 199 USD, converted at ECB rate. Etsy tags: Gold Rings,Rings For Men,Rings For Women,Tourmaline Jewellery,Natural Stone,bicolour Tourmaline,Lagoon tourmaline,Bluegreen tourmaline,blue tourmaline,indigo tourmaline,Oceangemsminerals,rare tourmaline,ink blue tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('c8f802ea-70bd-4ca1-8bc2-0decaf81a730', '7.35 Cts Hot Pink Rubelite Tourmaline', 'Gorgeous Hot Pink Rubelite Tourmaline 

Big Size And Very Best Price

7.35 Cts
12.6 x 9.3 x 7.4mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 268, 1, 'loose_stone', 'Tourmaline', 'Rubellite', 7.35, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/c8f802ea-70bd-4ca1-8bc2-0decaf81a730/etsy-1.jpg","https://media.gemworkers.com/items/c8f802ea-70bd-4ca1-8bc2-0decaf81a730/etsy-2.jpg","https://media.gemworkers.com/items/c8f802ea-70bd-4ca1-8bc2-0decaf81a730/etsy-3.jpg","https://media.gemworkers.com/items/c8f802ea-70bd-4ca1-8bc2-0decaf81a730/etsy-4.jpg","https://media.gemworkers.com/items/c8f802ea-70bd-4ca1-8bc2-0decaf81a730/etsy-5.jpg","https://media.gemworkers.com/items/c8f802ea-70bd-4ca1-8bc2-0decaf81a730/etsy-6.jpg","https://media.gemworkers.com/items/c8f802ea-70bd-4ca1-8bc2-0decaf81a730/etsy-7.jpg","https://media.gemworkers.com/items/c8f802ea-70bd-4ca1-8bc2-0decaf81a730/etsy-8.jpg","https://media.gemworkers.com/items/c8f802ea-70bd-4ca1-8bc2-0decaf81a730/etsy-9.jpg","https://media.gemworkers.com/items/c8f802ea-70bd-4ca1-8bc2-0decaf81a730/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 300 USD, converted at ECB rate. Etsy tags: Red Tourmaline,Hot Pink Tourmaline,Pink Tourmaline,Orange Tourmaline,Unique Tourmaline,Tourmaline Rings,Tourmaline Jewellery,Faceted Tourmaline,Step Cushion Cut,Afghan Tourmaline,Oceangemsminerals,Pink Rubelite,Red Rubelite.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('54ec710b-baae-40ee-9a87-2196050e38d8', '45 Cts Watermelon Slices Lot', 'unique watermelon tourmaline slices lot

45 Cts
4 to 16mm

Unheated, Untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 80, 1, 'loose_stone', 'Tourmaline', 'Watermelon', 45, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/54ec710b-baae-40ee-9a87-2196050e38d8/etsy-1.jpg","https://media.gemworkers.com/items/54ec710b-baae-40ee-9a87-2196050e38d8/etsy-2.jpg","https://media.gemworkers.com/items/54ec710b-baae-40ee-9a87-2196050e38d8/etsy-3.jpg","https://media.gemworkers.com/items/54ec710b-baae-40ee-9a87-2196050e38d8/etsy-4.jpg","https://media.gemworkers.com/items/54ec710b-baae-40ee-9a87-2196050e38d8/etsy-5.jpg","https://media.gemworkers.com/items/54ec710b-baae-40ee-9a87-2196050e38d8/etsy-6.jpg","https://media.gemworkers.com/items/54ec710b-baae-40ee-9a87-2196050e38d8/etsy-7.jpg","https://media.gemworkers.com/items/54ec710b-baae-40ee-9a87-2196050e38d8/etsy-8.jpg","https://media.gemworkers.com/items/54ec710b-baae-40ee-9a87-2196050e38d8/etsy-9.jpg","https://media.gemworkers.com/items/54ec710b-baae-40ee-9a87-2196050e38d8/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 90 USD, converted at ECB rate. Etsy tags: y2k earrings stud,Natural Stone,Tourmaline Earrings,Tourmaline Jewellery,Earrings Findings,pink tourmaline,lagoon tourmaline,tourmaline pairs,tourmaline lot,Tourmaline Slices,Slices Pairs,Watermelon Slices,WatermelonTourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('412d9474-e15d-4f50-97cb-66e6c8e035c1', '27 Cts tourmaline slices pairs', 'unique tourmaline slices pairs

27 Cts
7 to 13mm

Unheated, Untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 80, 1, 'loose_stone', 'Tourmaline', NULL, 27, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/412d9474-e15d-4f50-97cb-66e6c8e035c1/etsy-1.jpg","https://media.gemworkers.com/items/412d9474-e15d-4f50-97cb-66e6c8e035c1/etsy-2.jpg","https://media.gemworkers.com/items/412d9474-e15d-4f50-97cb-66e6c8e035c1/etsy-3.jpg","https://media.gemworkers.com/items/412d9474-e15d-4f50-97cb-66e6c8e035c1/etsy-4.jpg","https://media.gemworkers.com/items/412d9474-e15d-4f50-97cb-66e6c8e035c1/etsy-5.jpg","https://media.gemworkers.com/items/412d9474-e15d-4f50-97cb-66e6c8e035c1/etsy-6.jpg","https://media.gemworkers.com/items/412d9474-e15d-4f50-97cb-66e6c8e035c1/etsy-7.jpg","https://media.gemworkers.com/items/412d9474-e15d-4f50-97cb-66e6c8e035c1/etsy-8.jpg","https://media.gemworkers.com/items/412d9474-e15d-4f50-97cb-66e6c8e035c1/etsy-9.jpg","https://media.gemworkers.com/items/412d9474-e15d-4f50-97cb-66e6c8e035c1/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 90 USD, converted at ECB rate. Etsy tags: y2k earrings stud,Natural Stone,Tourmaline Earrings,Tourmaline Jewellery,Earrings Findings,Rings For Women,pink tourmaline,lagoon tourmaline,Blue tourmaline,tourmaline pairs,tourmaline lot,Tourmaline Slices,Slices Pairs.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('73f94b49-e15c-4041-a179-368b19104f93', '29.60 Cts tourmaline slices pairs', 'unique tourmaline slices pairs

29.60 Cts
8 to 14mm

Unheated, Untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 54, 1, 'loose_stone', 'Tourmaline', NULL, 29.6, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/73f94b49-e15c-4041-a179-368b19104f93/etsy-1.jpg","https://media.gemworkers.com/items/73f94b49-e15c-4041-a179-368b19104f93/etsy-2.jpg","https://media.gemworkers.com/items/73f94b49-e15c-4041-a179-368b19104f93/etsy-3.jpg","https://media.gemworkers.com/items/73f94b49-e15c-4041-a179-368b19104f93/etsy-4.jpg","https://media.gemworkers.com/items/73f94b49-e15c-4041-a179-368b19104f93/etsy-5.jpg","https://media.gemworkers.com/items/73f94b49-e15c-4041-a179-368b19104f93/etsy-6.jpg","https://media.gemworkers.com/items/73f94b49-e15c-4041-a179-368b19104f93/etsy-7.jpg","https://media.gemworkers.com/items/73f94b49-e15c-4041-a179-368b19104f93/etsy-8.jpg","https://media.gemworkers.com/items/73f94b49-e15c-4041-a179-368b19104f93/etsy-9.jpg","https://media.gemworkers.com/items/73f94b49-e15c-4041-a179-368b19104f93/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 60 USD, converted at ECB rate. Etsy tags: y2k earrings stud,Natural Stone,Tourmaline Earrings,Tourmaline Jewellery,Earrings Findings,Rings For Women,pink tourmaline,lagoon tourmaline,Blue tourmaline,tourmaline pairs,tourmaline lot,Tourmaline Slices,Slices Pairs.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('d540dca2-0268-4b49-8851-c80eb1f2cd10', '18 Cts tourmaline slices pairs', 'unique tourmaline slices pairs

18 Cts
7 to 10mm

Unheated, Untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 71, 1, 'loose_stone', 'Tourmaline', NULL, 18, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/d540dca2-0268-4b49-8851-c80eb1f2cd10/etsy-1.jpg","https://media.gemworkers.com/items/d540dca2-0268-4b49-8851-c80eb1f2cd10/etsy-2.jpg","https://media.gemworkers.com/items/d540dca2-0268-4b49-8851-c80eb1f2cd10/etsy-3.jpg","https://media.gemworkers.com/items/d540dca2-0268-4b49-8851-c80eb1f2cd10/etsy-4.jpg","https://media.gemworkers.com/items/d540dca2-0268-4b49-8851-c80eb1f2cd10/etsy-5.jpg","https://media.gemworkers.com/items/d540dca2-0268-4b49-8851-c80eb1f2cd10/etsy-6.jpg","https://media.gemworkers.com/items/d540dca2-0268-4b49-8851-c80eb1f2cd10/etsy-7.jpg","https://media.gemworkers.com/items/d540dca2-0268-4b49-8851-c80eb1f2cd10/etsy-8.jpg","https://media.gemworkers.com/items/d540dca2-0268-4b49-8851-c80eb1f2cd10/etsy-9.jpg","https://media.gemworkers.com/items/d540dca2-0268-4b49-8851-c80eb1f2cd10/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 80 USD, converted at ECB rate. Etsy tags: y2k earrings stud,Natural Stone,Tourmaline Earrings,Tourmaline Jewellery,Earrings Findings,Rings For Women,pink tourmaline,lagoon tourmaline,Blue tourmaline,tourmaline pairs,tourmaline lot,Tourmaline Slices,Slices Pairs.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('cfa0ec5f-f2aa-41d2-9928-861742486903', '31+Cts tourmaline slices pairs', 'unique tourmaline slices pairs

31.40 Cts
11 to 13mm

Unheated, Untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 80, 1, 'loose_stone', 'Tourmaline', NULL, NULL, NULL, NULL, NULL, NULL, '["https://media.gemworkers.com/items/cfa0ec5f-f2aa-41d2-9928-861742486903/etsy-1.jpg","https://media.gemworkers.com/items/cfa0ec5f-f2aa-41d2-9928-861742486903/etsy-2.jpg","https://media.gemworkers.com/items/cfa0ec5f-f2aa-41d2-9928-861742486903/etsy-3.jpg","https://media.gemworkers.com/items/cfa0ec5f-f2aa-41d2-9928-861742486903/etsy-4.jpg","https://media.gemworkers.com/items/cfa0ec5f-f2aa-41d2-9928-861742486903/etsy-5.jpg","https://media.gemworkers.com/items/cfa0ec5f-f2aa-41d2-9928-861742486903/etsy-6.jpg","https://media.gemworkers.com/items/cfa0ec5f-f2aa-41d2-9928-861742486903/etsy-7.jpg","https://media.gemworkers.com/items/cfa0ec5f-f2aa-41d2-9928-861742486903/etsy-8.jpg","https://media.gemworkers.com/items/cfa0ec5f-f2aa-41d2-9928-861742486903/etsy-9.jpg","https://media.gemworkers.com/items/cfa0ec5f-f2aa-41d2-9928-861742486903/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 90 USD, converted at ECB rate. Etsy tags: y2k earrings stud,Natural Stone,Tourmaline Earrings,Tourmaline Jewellery,Earrings Findings,Rings For Women,pink tourmaline,lagoon tourmaline,Blue tourmaline,tourmaline pairs,tourmaline lot,Tourmaline Slices,Slices Pairs.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('625789c6-54bd-4faf-b060-7f086b0c3b01', '1.5 Cts Rare Tourmaline', 'unique tourmaline the play of the stone is very beautiful.

we do not list every stone unless it has some unique characteristics.

More Beautiful In Real.

1.55 Cts
8.9 x 4.5 x 4mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 54, 1, 'loose_stone', 'Tourmaline', NULL, 1.5, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/625789c6-54bd-4faf-b060-7f086b0c3b01/etsy-1.jpg","https://media.gemworkers.com/items/625789c6-54bd-4faf-b060-7f086b0c3b01/etsy-2.jpg","https://media.gemworkers.com/items/625789c6-54bd-4faf-b060-7f086b0c3b01/etsy-3.jpg","https://media.gemworkers.com/items/625789c6-54bd-4faf-b060-7f086b0c3b01/etsy-4.jpg","https://media.gemworkers.com/items/625789c6-54bd-4faf-b060-7f086b0c3b01/etsy-5.jpg","https://media.gemworkers.com/items/625789c6-54bd-4faf-b060-7f086b0c3b01/etsy-6.jpg","https://media.gemworkers.com/items/625789c6-54bd-4faf-b060-7f086b0c3b01/etsy-7.jpg","https://media.gemworkers.com/items/625789c6-54bd-4faf-b060-7f086b0c3b01/etsy-8.jpg","https://media.gemworkers.com/items/625789c6-54bd-4faf-b060-7f086b0c3b01/etsy-9.jpg","https://media.gemworkers.com/items/625789c6-54bd-4faf-b060-7f086b0c3b01/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 60 USD, converted at ECB rate. Etsy tags: Paraiba Tourmaline,Paraiba Colour,Lagoon Tourmaline,Bluegreen Tourmaline,Blue Tourmaline,Neon Blue Tourmaline,Tourmaline Jewellery,Jewellers,Lagoon Colour,Oceangemsminerals,Ink Blue Tourmaline,Wedding Rings,Rings For Women.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('7e7ec696-9cd1-4a80-b4c9-96fd7eb8f645', '13.90 Cts Tricolour Tourmaline Lot', 'To All The Bicolour Lovers Here Is An Incredible Opportunity Buy A Truly Exceptional And One Of A Kind Bicolour And Tricolour Tourmaline Lot

13.90 Cts
8 to 10mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 170, 1, 'loose_stone', 'Tourmaline', NULL, 13.9, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/7e7ec696-9cd1-4a80-b4c9-96fd7eb8f645/etsy-1.jpg","https://media.gemworkers.com/items/7e7ec696-9cd1-4a80-b4c9-96fd7eb8f645/etsy-2.jpg","https://media.gemworkers.com/items/7e7ec696-9cd1-4a80-b4c9-96fd7eb8f645/etsy-3.jpg","https://media.gemworkers.com/items/7e7ec696-9cd1-4a80-b4c9-96fd7eb8f645/etsy-4.jpg","https://media.gemworkers.com/items/7e7ec696-9cd1-4a80-b4c9-96fd7eb8f645/etsy-5.jpg","https://media.gemworkers.com/items/7e7ec696-9cd1-4a80-b4c9-96fd7eb8f645/etsy-6.jpg","https://media.gemworkers.com/items/7e7ec696-9cd1-4a80-b4c9-96fd7eb8f645/etsy-7.jpg","https://media.gemworkers.com/items/7e7ec696-9cd1-4a80-b4c9-96fd7eb8f645/etsy-8.jpg","https://media.gemworkers.com/items/7e7ec696-9cd1-4a80-b4c9-96fd7eb8f645/etsy-9.jpg","https://media.gemworkers.com/items/7e7ec696-9cd1-4a80-b4c9-96fd7eb8f645/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 190 USD, converted at ECB rate. Etsy tags: pink tourmaline,rings for women,unique tourmaline,Handmadejewellery,gift for her,Bicolour Tourmaline,Unique Bicolour,Rare Tourmaline,Oceangemsminerals,Tourmaline Pairs,Bicolour Pairs,Canary Tourmaline,Mix Bicolour Lot.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('b2599264-8381-4cc1-848d-cc1b8135eb43', '19.30 Cts Tricolour Tourmaline Lot', 'To All The Bicolour Lovers Here Is An Incredible Opportunity Buy A Truly Exceptional And One Of A Kind Bicolour And Tricolour Tourmaline Lot

19.30 Cts
7.7 to 10.2nm 

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 268, 1, 'loose_stone', 'Tourmaline', NULL, 19.3, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/b2599264-8381-4cc1-848d-cc1b8135eb43/etsy-1.jpg","https://media.gemworkers.com/items/b2599264-8381-4cc1-848d-cc1b8135eb43/etsy-2.jpg","https://media.gemworkers.com/items/b2599264-8381-4cc1-848d-cc1b8135eb43/etsy-3.jpg","https://media.gemworkers.com/items/b2599264-8381-4cc1-848d-cc1b8135eb43/etsy-4.jpg","https://media.gemworkers.com/items/b2599264-8381-4cc1-848d-cc1b8135eb43/etsy-5.jpg","https://media.gemworkers.com/items/b2599264-8381-4cc1-848d-cc1b8135eb43/etsy-6.jpg","https://media.gemworkers.com/items/b2599264-8381-4cc1-848d-cc1b8135eb43/etsy-7.jpg","https://media.gemworkers.com/items/b2599264-8381-4cc1-848d-cc1b8135eb43/etsy-8.jpg","https://media.gemworkers.com/items/b2599264-8381-4cc1-848d-cc1b8135eb43/etsy-9.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 300 USD, converted at ECB rate. Etsy tags: pink tourmaline,rings for women,unique tourmaline,Handmadejewellery,gift for her,Bicolour Tourmaline,Unique Bicolour,Rare Tourmaline,Oceangemsminerals,Tourmaline Pairs,Bicolour Pairs,Canary Tourmaline,Mix Bicolour Lot.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('038d9b6b-b7c2-4e5f-8d04-94be6644d51c', '8.65 Cts, pink tourmaline lot', 'Elegant Afghan pink colour tourmaline 

High lustre, glowing and bright colour 

8.65 Cts
6.3 to 7.3mm

Unheated, Untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 223, 1, 'loose_stone', 'Tourmaline', NULL, 8.65, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/038d9b6b-b7c2-4e5f-8d04-94be6644d51c/etsy-1.jpg","https://media.gemworkers.com/items/038d9b6b-b7c2-4e5f-8d04-94be6644d51c/etsy-2.jpg","https://media.gemworkers.com/items/038d9b6b-b7c2-4e5f-8d04-94be6644d51c/etsy-3.jpg","https://media.gemworkers.com/items/038d9b6b-b7c2-4e5f-8d04-94be6644d51c/etsy-4.jpg","https://media.gemworkers.com/items/038d9b6b-b7c2-4e5f-8d04-94be6644d51c/etsy-5.jpg","https://media.gemworkers.com/items/038d9b6b-b7c2-4e5f-8d04-94be6644d51c/etsy-6.jpg","https://media.gemworkers.com/items/038d9b6b-b7c2-4e5f-8d04-94be6644d51c/etsy-7.jpg","https://media.gemworkers.com/items/038d9b6b-b7c2-4e5f-8d04-94be6644d51c/etsy-8.jpg","https://media.gemworkers.com/items/038d9b6b-b7c2-4e5f-8d04-94be6644d51c/etsy-9.jpg","https://media.gemworkers.com/items/038d9b6b-b7c2-4e5f-8d04-94be6644d51c/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 250 USD, converted at ECB rate. Etsy tags: Jewellery Supplies,Jewellery Making,Rings For Men,Rings For Women,y2k earrings stud,Gift For Her,Tourmaline Jewellery,Natural Stone,Tourmaline Supplies,Jewellery Stud,pink tourmaline,Oceangemsminerals,orange tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('2eaab9ce-a63b-41a3-b98a-6bc456af1cd1', '16.30 Cts Tricolour Tourmaline Lot', 'To All The Bicolour Lovers Here Is An Incredible Opportunity Buy A Truly Exceptional And One Of A Kind Bicolour And Tricolour Tourmaline Lot

16.30 Cts
6.9 to 9mm 

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 286, 1, 'loose_stone', 'Tourmaline', NULL, 16.3, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/2eaab9ce-a63b-41a3-b98a-6bc456af1cd1/etsy-1.jpg","https://media.gemworkers.com/items/2eaab9ce-a63b-41a3-b98a-6bc456af1cd1/etsy-2.jpg","https://media.gemworkers.com/items/2eaab9ce-a63b-41a3-b98a-6bc456af1cd1/etsy-3.jpg","https://media.gemworkers.com/items/2eaab9ce-a63b-41a3-b98a-6bc456af1cd1/etsy-4.jpg","https://media.gemworkers.com/items/2eaab9ce-a63b-41a3-b98a-6bc456af1cd1/etsy-5.jpg","https://media.gemworkers.com/items/2eaab9ce-a63b-41a3-b98a-6bc456af1cd1/etsy-6.jpg","https://media.gemworkers.com/items/2eaab9ce-a63b-41a3-b98a-6bc456af1cd1/etsy-7.jpg","https://media.gemworkers.com/items/2eaab9ce-a63b-41a3-b98a-6bc456af1cd1/etsy-8.jpg","https://media.gemworkers.com/items/2eaab9ce-a63b-41a3-b98a-6bc456af1cd1/etsy-9.jpg","https://media.gemworkers.com/items/2eaab9ce-a63b-41a3-b98a-6bc456af1cd1/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 320 USD, converted at ECB rate. Etsy tags: pink tourmaline,rings for women,unique tourmaline,Handmadejewellery,gift for her,Bicolour Tourmaline,Unique Bicolour,Rare Tourmaline,Oceangemsminerals,Tourmaline Pairs,Bicolour Pairs,Canary Tourmaline,Mix Bicolour Lot.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('5a31cfac-7694-40e6-9d09-73ede04cb4bc', '14.95 Cts Tricolour Tourmaline Lot', 'To All The Bicolour Lovers Here Is An Incredible Opportunity Buy A Truly Exceptional And One Of A Kind Bicolour And Tricolour Tourmaline Lot

14.95 Cts
7.2 to 9.8mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 313, 1, 'loose_stone', 'Tourmaline', NULL, 14.95, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/5a31cfac-7694-40e6-9d09-73ede04cb4bc/etsy-1.jpg","https://media.gemworkers.com/items/5a31cfac-7694-40e6-9d09-73ede04cb4bc/etsy-2.jpg","https://media.gemworkers.com/items/5a31cfac-7694-40e6-9d09-73ede04cb4bc/etsy-3.jpg","https://media.gemworkers.com/items/5a31cfac-7694-40e6-9d09-73ede04cb4bc/etsy-4.jpg","https://media.gemworkers.com/items/5a31cfac-7694-40e6-9d09-73ede04cb4bc/etsy-5.jpg","https://media.gemworkers.com/items/5a31cfac-7694-40e6-9d09-73ede04cb4bc/etsy-6.jpg","https://media.gemworkers.com/items/5a31cfac-7694-40e6-9d09-73ede04cb4bc/etsy-7.jpg","https://media.gemworkers.com/items/5a31cfac-7694-40e6-9d09-73ede04cb4bc/etsy-8.jpg","https://media.gemworkers.com/items/5a31cfac-7694-40e6-9d09-73ede04cb4bc/etsy-9.jpg","https://media.gemworkers.com/items/5a31cfac-7694-40e6-9d09-73ede04cb4bc/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 350 USD, converted at ECB rate. Etsy tags: pink tourmaline,rings for women,unique tourmaline,Handmadejewellery,gift for her,Bicolour Tourmaline,Unique Bicolour,Rare Tourmaline,Oceangemsminerals,Tourmaline Pairs,Bicolour Pairs,Canary Tourmaline,Mix Bicolour Lot.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('6c6f2bed-48e5-45dd-b7c0-5e8b76dd54c7', '2.65 Cts Pink Tourmaline Pair', 'Gorgeous Unique Pink Tourmaline Pair

2.65 Cts
6.1 x 6 x 4.5mm

Unheated, Untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 179, 1, 'loose_stone', 'Tourmaline', NULL, 2.65, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/6c6f2bed-48e5-45dd-b7c0-5e8b76dd54c7/etsy-1.jpg","https://media.gemworkers.com/items/6c6f2bed-48e5-45dd-b7c0-5e8b76dd54c7/etsy-2.jpg","https://media.gemworkers.com/items/6c6f2bed-48e5-45dd-b7c0-5e8b76dd54c7/etsy-3.jpg","https://media.gemworkers.com/items/6c6f2bed-48e5-45dd-b7c0-5e8b76dd54c7/etsy-4.jpg","https://media.gemworkers.com/items/6c6f2bed-48e5-45dd-b7c0-5e8b76dd54c7/etsy-5.jpg","https://media.gemworkers.com/items/6c6f2bed-48e5-45dd-b7c0-5e8b76dd54c7/etsy-6.jpg","https://media.gemworkers.com/items/6c6f2bed-48e5-45dd-b7c0-5e8b76dd54c7/etsy-7.jpg","https://media.gemworkers.com/items/6c6f2bed-48e5-45dd-b7c0-5e8b76dd54c7/etsy-8.jpg","https://media.gemworkers.com/items/6c6f2bed-48e5-45dd-b7c0-5e8b76dd54c7/etsy-9.jpg","https://media.gemworkers.com/items/6c6f2bed-48e5-45dd-b7c0-5e8b76dd54c7/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 200 USD, converted at ECB rate. Etsy tags: Rings For Men,Rings For Women,Jewellery Stud,Tourmaline Rings,Gift For Her,Gold rings,Natural Stone,Handmade,Oceangemsminerals,Unique Tourmaline,Rare Tourmaline,Pink Tourmaline Lot,Tourmaline Pair.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('c3113e0c-4670-4ec0-92d2-fbea31a08f52', '22.65 Cts Tricolour Tourmaline Lot', 'To All The Bicolour Lovers Here Is An Incredible Opportunity Buy A Truly Exceptional And One Of A Kind Bicolour And Tricolour Tourmaline Lot

22.65 Cts
11.5 to 6mm 

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 268, 1, 'loose_stone', 'Tourmaline', NULL, 22.65, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/c3113e0c-4670-4ec0-92d2-fbea31a08f52/etsy-1.jpg","https://media.gemworkers.com/items/c3113e0c-4670-4ec0-92d2-fbea31a08f52/etsy-2.jpg","https://media.gemworkers.com/items/c3113e0c-4670-4ec0-92d2-fbea31a08f52/etsy-3.jpg","https://media.gemworkers.com/items/c3113e0c-4670-4ec0-92d2-fbea31a08f52/etsy-4.jpg","https://media.gemworkers.com/items/c3113e0c-4670-4ec0-92d2-fbea31a08f52/etsy-5.jpg","https://media.gemworkers.com/items/c3113e0c-4670-4ec0-92d2-fbea31a08f52/etsy-6.jpg","https://media.gemworkers.com/items/c3113e0c-4670-4ec0-92d2-fbea31a08f52/etsy-7.jpg","https://media.gemworkers.com/items/c3113e0c-4670-4ec0-92d2-fbea31a08f52/etsy-8.jpg","https://media.gemworkers.com/items/c3113e0c-4670-4ec0-92d2-fbea31a08f52/etsy-9.jpg","https://media.gemworkers.com/items/c3113e0c-4670-4ec0-92d2-fbea31a08f52/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 300 USD, converted at ECB rate. Etsy tags: pink tourmaline,rings for women,unique tourmaline,Handmadejewellery,gift for her,Bicolour Tourmaline,Unique Bicolour,Rare Tourmaline,Oceangemsminerals,Tourmaline Pairs,Bicolour Pairs,Canary Tourmaline,Mix Bicolour Lot.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('cf76bd97-4a86-4e8c-b6c2-1cfc7c9ca962', '3.05 Cts Rare Tourmaline Set', 'Top Quality Lagoon Green Tourmaline Pairs And Sharp Yellow Tourmaline Makes It Unique And Lovely Tourmaline Set

3.05 Cts
Pairs
5 x 4.4 x 3.4mm
5.4 x 3.8 x 3mm

Yellow Tourmaline 
5.1 x 5.1 x 4.1mm

No Treatment Whatsoever.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 268, 1, 'loose_stone', 'Tourmaline', NULL, 3.05, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/cf76bd97-4a86-4e8c-b6c2-1cfc7c9ca962/etsy-1.jpg","https://media.gemworkers.com/items/cf76bd97-4a86-4e8c-b6c2-1cfc7c9ca962/etsy-2.jpg","https://media.gemworkers.com/items/cf76bd97-4a86-4e8c-b6c2-1cfc7c9ca962/etsy-3.jpg","https://media.gemworkers.com/items/cf76bd97-4a86-4e8c-b6c2-1cfc7c9ca962/etsy-4.jpg","https://media.gemworkers.com/items/cf76bd97-4a86-4e8c-b6c2-1cfc7c9ca962/etsy-5.jpg","https://media.gemworkers.com/items/cf76bd97-4a86-4e8c-b6c2-1cfc7c9ca962/etsy-6.jpg","https://media.gemworkers.com/items/cf76bd97-4a86-4e8c-b6c2-1cfc7c9ca962/etsy-7.jpg","https://media.gemworkers.com/items/cf76bd97-4a86-4e8c-b6c2-1cfc7c9ca962/etsy-8.jpg","https://media.gemworkers.com/items/cf76bd97-4a86-4e8c-b6c2-1cfc7c9ca962/etsy-9.jpg","https://media.gemworkers.com/items/cf76bd97-4a86-4e8c-b6c2-1cfc7c9ca962/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 300 USD, converted at ECB rate. Etsy tags: Emerald Cut,EmeraldCutTourmaline,Jewellery making,earrings stud,Tourmaline Lot,Blue Tourmaline,Lagoon Tourmaline,Neon Blue,neon blue tourmaline,Rings For Men,Tourmalines,Ink Blue Tourmaline,Oceangemsminerals.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('ff124fa9-4d0e-4b73-a3f9-490bc9a212ef', '16 Cts Spinel Lot', 'A Very Unique Spinel Lot

Top Quality 

Purplish Pink Colour

Bright And Brilliance 

16 Cts
6.9 to 8.4mm

Unheated, Untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 715, 1, 'loose_stone', 'Spinel', NULL, 16, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/ff124fa9-4d0e-4b73-a3f9-490bc9a212ef/etsy-1.jpg","https://media.gemworkers.com/items/ff124fa9-4d0e-4b73-a3f9-490bc9a212ef/etsy-2.jpg","https://media.gemworkers.com/items/ff124fa9-4d0e-4b73-a3f9-490bc9a212ef/etsy-3.jpg","https://media.gemworkers.com/items/ff124fa9-4d0e-4b73-a3f9-490bc9a212ef/etsy-4.jpg","https://media.gemworkers.com/items/ff124fa9-4d0e-4b73-a3f9-490bc9a212ef/etsy-5.jpg","https://media.gemworkers.com/items/ff124fa9-4d0e-4b73-a3f9-490bc9a212ef/etsy-6.jpg","https://media.gemworkers.com/items/ff124fa9-4d0e-4b73-a3f9-490bc9a212ef/etsy-7.jpg","https://media.gemworkers.com/items/ff124fa9-4d0e-4b73-a3f9-490bc9a212ef/etsy-8.jpg","https://media.gemworkers.com/items/ff124fa9-4d0e-4b73-a3f9-490bc9a212ef/etsy-9.jpg","https://media.gemworkers.com/items/ff124fa9-4d0e-4b73-a3f9-490bc9a212ef/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 800 USD, converted at ECB rate. Etsy tags: Spinel Jewellery,Spinel Rings,Pink Spinel,Orange Spinel,Bicolour Spinel,Unique Spinel,Faceted Spinel,Jewellery Making,Jewellery Supplies,Oceangemsminerals,Spinel Necklace,Gift For Her,Natural Stone.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('e709bb58-98c5-4eb7-b9a2-7c8790b767c6', '3.55 Cts Neon Blue Colour Tourmaline', 'Gorgeous Neon Blue Green Colours.

Exceptional Colour Very Rare To Be Find, Bright Colour Not Dull.

More Beautiful In Real

3.55 Cts
10.5 x 6.5 x 5.2mn
4.9 x 4.7 x 3.5mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 268, 1, 'loose_stone', 'Tourmaline', NULL, 3.55, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/e709bb58-98c5-4eb7-b9a2-7c8790b767c6/etsy-1.jpg","https://media.gemworkers.com/items/e709bb58-98c5-4eb7-b9a2-7c8790b767c6/etsy-2.jpg","https://media.gemworkers.com/items/e709bb58-98c5-4eb7-b9a2-7c8790b767c6/etsy-3.jpg","https://media.gemworkers.com/items/e709bb58-98c5-4eb7-b9a2-7c8790b767c6/etsy-4.jpg","https://media.gemworkers.com/items/e709bb58-98c5-4eb7-b9a2-7c8790b767c6/etsy-5.jpg","https://media.gemworkers.com/items/e709bb58-98c5-4eb7-b9a2-7c8790b767c6/etsy-6.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 300 USD, converted at ECB rate. Etsy tags: Paraiba Tourmaline,Paraiba Colour,Lagoon Tourmaline,Bluegreen Tourmaline,Blue Tourmaline,Neon Blue Tourmaline,Tourmaline Jewellery,Jewellers,Lagoon Colour,Oceangemsminerals,Ink Blue Tourmaline,Wedding Rings,Rings For Women.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('35fd45bf-3d14-40a2-9e24-61274c5065ac', '3.20 Cts Bright Tourmaline', 'One Of The brightest Colour Tourmalines

Included But Fine Colour 

Bright And Lustre, Inclusions Give It Special Characteristics. 

More Beautiful In Real And At very reasonable price 

3.20 Cts
6mm to 11mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 197, 1, 'loose_stone', 'Tourmaline', NULL, 3.2, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/35fd45bf-3d14-40a2-9e24-61274c5065ac/etsy-1.jpg","https://media.gemworkers.com/items/35fd45bf-3d14-40a2-9e24-61274c5065ac/etsy-2.jpg","https://media.gemworkers.com/items/35fd45bf-3d14-40a2-9e24-61274c5065ac/etsy-3.jpg","https://media.gemworkers.com/items/35fd45bf-3d14-40a2-9e24-61274c5065ac/etsy-4.jpg","https://media.gemworkers.com/items/35fd45bf-3d14-40a2-9e24-61274c5065ac/etsy-5.jpg","https://media.gemworkers.com/items/35fd45bf-3d14-40a2-9e24-61274c5065ac/etsy-6.jpg","https://media.gemworkers.com/items/35fd45bf-3d14-40a2-9e24-61274c5065ac/etsy-7.jpg","https://media.gemworkers.com/items/35fd45bf-3d14-40a2-9e24-61274c5065ac/etsy-8.jpg","https://media.gemworkers.com/items/35fd45bf-3d14-40a2-9e24-61274c5065ac/etsy-9.jpg","https://media.gemworkers.com/items/35fd45bf-3d14-40a2-9e24-61274c5065ac/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 220 USD, converted at ECB rate. Etsy tags: Paraiba Tourmaline,Paraiba Colour,Lagoon Tourmaline,Bluegreen Tourmaline,Blue Tourmaline,Neon Blue Tourmaline,Tourmaline Jewellery,Jewellers,Lagoon Colour,Oceangemsminerals,Ink Blue Tourmaline,Wedding Rings,Rings For Women.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('227a01ec-b5dc-4aef-be42-8fb179369bea', '4.85 Cts Seafoam Tourmaline', 'Mesmerising Seafoam colour afghan tourmaline 

Ethically sourced 

4.85 Cts
9.5 x 9.5 x 6mm
7.2 x 7.2 x 4.5mm

Unheated, Untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 109, 1, 'loose_stone', 'Tourmaline', NULL, 4.85, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/227a01ec-b5dc-4aef-be42-8fb179369bea/etsy-1.jpg","https://media.gemworkers.com/items/227a01ec-b5dc-4aef-be42-8fb179369bea/etsy-2.jpg","https://media.gemworkers.com/items/227a01ec-b5dc-4aef-be42-8fb179369bea/etsy-3.jpg","https://media.gemworkers.com/items/227a01ec-b5dc-4aef-be42-8fb179369bea/etsy-4.jpg","https://media.gemworkers.com/items/227a01ec-b5dc-4aef-be42-8fb179369bea/etsy-5.jpg","https://media.gemworkers.com/items/227a01ec-b5dc-4aef-be42-8fb179369bea/etsy-6.jpg","https://media.gemworkers.com/items/227a01ec-b5dc-4aef-be42-8fb179369bea/etsy-7.jpg","https://media.gemworkers.com/items/227a01ec-b5dc-4aef-be42-8fb179369bea/etsy-8.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 122 USD, converted at ECB rate. Etsy tags: Jewellery Supplies,Jewellery Making,DIY Jewellery Making,Gift For Her,Rings For Men,Rings For Women,Natural Stone,Silver Sterling,Gold Ring,Tourmaline Jewellery,Tourmaline Supplies,Afghan Tourmaline,y2k earrings stud.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('e9b5575a-d611-48ca-b56c-1a842c57d940', '2.95 Cts Mint green tourmaline', 'Fresh Mint Green Colour Tourmalines

cute looking little pieces 

2.95 Cts
7.8 x 7.8 x 5mm
5.2 x 5.2 x 3mm

unheated,untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 89, 1, 'loose_stone', 'Tourmaline', NULL, 2.95, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/e9b5575a-d611-48ca-b56c-1a842c57d940/etsy-1.jpg","https://media.gemworkers.com/items/e9b5575a-d611-48ca-b56c-1a842c57d940/etsy-2.jpg","https://media.gemworkers.com/items/e9b5575a-d611-48ca-b56c-1a842c57d940/etsy-3.jpg","https://media.gemworkers.com/items/e9b5575a-d611-48ca-b56c-1a842c57d940/etsy-4.jpg","https://media.gemworkers.com/items/e9b5575a-d611-48ca-b56c-1a842c57d940/etsy-5.jpg","https://media.gemworkers.com/items/e9b5575a-d611-48ca-b56c-1a842c57d940/etsy-6.jpg","https://media.gemworkers.com/items/e9b5575a-d611-48ca-b56c-1a842c57d940/etsy-7.jpg","https://media.gemworkers.com/items/e9b5575a-d611-48ca-b56c-1a842c57d940/etsy-8.jpg","https://media.gemworkers.com/items/e9b5575a-d611-48ca-b56c-1a842c57d940/etsy-9.jpg","https://media.gemworkers.com/items/e9b5575a-d611-48ca-b56c-1a842c57d940/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 100 USD, converted at ECB rate. Etsy tags: jewellery making,jewellery supplies,jewellery findings,jewels,handmade,loose gemstones,gift for her,natural stone,Handmadejewellery,mintgreen tourmaline,green tourmaline,mint tourmaline,blue tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('3d0370aa-7d1e-4667-9060-3dcdaeca4ec7', '4.60 Cts peridot pair', 'bright Colour Peridot Lot

origin- pakistan 

pakistan peridot is one of the finest and top quality 

Weight:16 carats 
5x3mm
7x4mm

unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 116, 1, 'loose_stone', 'Peridot', NULL, 4.6, 'ct', 'Pakistan', NULL, NULL, '["https://media.gemworkers.com/items/3d0370aa-7d1e-4667-9060-3dcdaeca4ec7/etsy-1.jpg","https://media.gemworkers.com/items/3d0370aa-7d1e-4667-9060-3dcdaeca4ec7/etsy-2.jpg","https://media.gemworkers.com/items/3d0370aa-7d1e-4667-9060-3dcdaeca4ec7/etsy-3.jpg","https://media.gemworkers.com/items/3d0370aa-7d1e-4667-9060-3dcdaeca4ec7/etsy-4.jpg","https://media.gemworkers.com/items/3d0370aa-7d1e-4667-9060-3dcdaeca4ec7/etsy-5.jpg","https://media.gemworkers.com/items/3d0370aa-7d1e-4667-9060-3dcdaeca4ec7/etsy-6.jpg","https://media.gemworkers.com/items/3d0370aa-7d1e-4667-9060-3dcdaeca4ec7/etsy-7.jpg","https://media.gemworkers.com/items/3d0370aa-7d1e-4667-9060-3dcdaeca4ec7/etsy-8.jpg","https://media.gemworkers.com/items/3d0370aa-7d1e-4667-9060-3dcdaeca4ec7/etsy-9.jpg","https://media.gemworkers.com/items/3d0370aa-7d1e-4667-9060-3dcdaeca4ec7/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 130 USD, converted at ECB rate. Etsy tags: jewellery making,jewellery supplies,jewellery findings,loose gemstones,gift for her,peridot pairs,peridot jewellery,pakistan peridot,green peridot,trillion peridot,y2k earrings stud,necklace findings,gold rings.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('a884bc89-277d-4e96-992f-78998d29ba60', '6.50 Cts Peridot For Ring', 'Gorgeous Peridot 

origin- pakistan 

pakistan peridot is one of the finest and top quality 

6.50 Cts
10.6 x 9.1 x 7.8mm

Excellent Cut

unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 134, 1, 'jewelry', 'Peridot', NULL, 6.5, 'ct', 'Pakistan', NULL, NULL, '["https://media.gemworkers.com/items/a884bc89-277d-4e96-992f-78998d29ba60/etsy-1.jpg","https://media.gemworkers.com/items/a884bc89-277d-4e96-992f-78998d29ba60/etsy-2.jpg","https://media.gemworkers.com/items/a884bc89-277d-4e96-992f-78998d29ba60/etsy-3.jpg","https://media.gemworkers.com/items/a884bc89-277d-4e96-992f-78998d29ba60/etsy-4.jpg","https://media.gemworkers.com/items/a884bc89-277d-4e96-992f-78998d29ba60/etsy-5.jpg","https://media.gemworkers.com/items/a884bc89-277d-4e96-992f-78998d29ba60/etsy-6.jpg","https://media.gemworkers.com/items/a884bc89-277d-4e96-992f-78998d29ba60/etsy-7.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 150 USD, converted at ECB rate. Etsy tags: jewellery supplies,jewellery findings,loose gemstones,gift for her,peridot pairs,peridot jewellery,pakistan peridot,green peridot,trillion peridot,y2k earrings stud,necklace findings,gold rings,Apple Green Peridot.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('d7b5a96f-6a08-4d86-8686-f4785ba335ae', '5.75 Cts Peridot For Ring', 'Gorgeous Peridot 

origin- pakistan 

pakistan peridot is one of the finest and top quality 

5.75 Cts
11 x 8.7 x 6.8mm

Excellent Cut

unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 156, 1, 'jewelry', 'Peridot', NULL, 5.75, 'ct', 'Pakistan', NULL, NULL, '["https://media.gemworkers.com/items/d7b5a96f-6a08-4d86-8686-f4785ba335ae/etsy-1.jpg","https://media.gemworkers.com/items/d7b5a96f-6a08-4d86-8686-f4785ba335ae/etsy-2.jpg","https://media.gemworkers.com/items/d7b5a96f-6a08-4d86-8686-f4785ba335ae/etsy-3.jpg","https://media.gemworkers.com/items/d7b5a96f-6a08-4d86-8686-f4785ba335ae/etsy-4.jpg","https://media.gemworkers.com/items/d7b5a96f-6a08-4d86-8686-f4785ba335ae/etsy-5.jpg","https://media.gemworkers.com/items/d7b5a96f-6a08-4d86-8686-f4785ba335ae/etsy-6.jpg","https://media.gemworkers.com/items/d7b5a96f-6a08-4d86-8686-f4785ba335ae/etsy-7.jpg","https://media.gemworkers.com/items/d7b5a96f-6a08-4d86-8686-f4785ba335ae/etsy-8.jpg","https://media.gemworkers.com/items/d7b5a96f-6a08-4d86-8686-f4785ba335ae/etsy-9.jpg","https://media.gemworkers.com/items/d7b5a96f-6a08-4d86-8686-f4785ba335ae/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 175 USD, converted at ECB rate. Etsy tags: jewellery supplies,jewellery findings,loose gemstones,gift for her,peridot pairs,peridot jewellery,pakistan peridot,green peridot,trillion peridot,y2k earrings stud,necklace findings,gold rings,Apple Green Peridot.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('0defb27c-dcb2-4a74-b52a-8c7e88a2b580', '2.8 Cts Apple Green Peridot & Tourmaline Set', 'Mesmerising Apple 🍏 Green Colour Peridot Tourmaline Set

Ethically Sourced, Eye Clean

high lustre and brilliance 

2.8 Cts
6.4 x 5.7 x 4.8mm
5 x 4.6 x 3.6mm 

Unheated, No treatment Whatsoever.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 152, 1, 'loose_stone', 'Peridot', NULL, 2.8, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/0defb27c-dcb2-4a74-b52a-8c7e88a2b580/etsy-1.jpg","https://media.gemworkers.com/items/0defb27c-dcb2-4a74-b52a-8c7e88a2b580/etsy-2.jpg","https://media.gemworkers.com/items/0defb27c-dcb2-4a74-b52a-8c7e88a2b580/etsy-3.jpg","https://media.gemworkers.com/items/0defb27c-dcb2-4a74-b52a-8c7e88a2b580/etsy-4.jpg","https://media.gemworkers.com/items/0defb27c-dcb2-4a74-b52a-8c7e88a2b580/etsy-5.jpg","https://media.gemworkers.com/items/0defb27c-dcb2-4a74-b52a-8c7e88a2b580/etsy-6.jpg","https://media.gemworkers.com/items/0defb27c-dcb2-4a74-b52a-8c7e88a2b580/etsy-7.jpg","https://media.gemworkers.com/items/0defb27c-dcb2-4a74-b52a-8c7e88a2b580/etsy-8.jpg","https://media.gemworkers.com/items/0defb27c-dcb2-4a74-b52a-8c7e88a2b580/etsy-9.jpg","https://media.gemworkers.com/items/0defb27c-dcb2-4a74-b52a-8c7e88a2b580/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 170 USD, converted at ECB rate. Etsy tags: Jewellery Making,Rings For Women,Jewellery Finding,Rings For Men,Jewels,Gold Rings,Jewellery Supplies,Gift For Her,Natural Stone,Blue tourmaline,lagoon Tourmaline,Oceangemsminerals,AppleGreenTourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('b32cc4ca-bd3b-4aab-80e0-dea975389c2f', '2.9 Cts Seafoam Tourmaline lot', 'blue tourmaline lot 

Bright colour 

More Beautiful In Real And At very reasonable price 

2.9 Cts
9 x 4.9 x 3.9mm
6 x 5.6 x 4.7mm 

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 178, 1, 'loose_stone', 'Tourmaline', NULL, 2.9, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/b32cc4ca-bd3b-4aab-80e0-dea975389c2f/etsy-1.jpg","https://media.gemworkers.com/items/b32cc4ca-bd3b-4aab-80e0-dea975389c2f/etsy-2.jpg","https://media.gemworkers.com/items/b32cc4ca-bd3b-4aab-80e0-dea975389c2f/etsy-3.jpg","https://media.gemworkers.com/items/b32cc4ca-bd3b-4aab-80e0-dea975389c2f/etsy-4.jpg","https://media.gemworkers.com/items/b32cc4ca-bd3b-4aab-80e0-dea975389c2f/etsy-5.jpg","https://media.gemworkers.com/items/b32cc4ca-bd3b-4aab-80e0-dea975389c2f/etsy-6.jpg","https://media.gemworkers.com/items/b32cc4ca-bd3b-4aab-80e0-dea975389c2f/etsy-7.jpg","https://media.gemworkers.com/items/b32cc4ca-bd3b-4aab-80e0-dea975389c2f/etsy-8.jpg","https://media.gemworkers.com/items/b32cc4ca-bd3b-4aab-80e0-dea975389c2f/etsy-9.jpg","https://media.gemworkers.com/items/b32cc4ca-bd3b-4aab-80e0-dea975389c2f/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 199 USD, converted at ECB rate. Etsy tags: Paraiba Tourmaline,Paraiba Colour,Lagoon Tourmaline,Bluegreen Tourmaline,Blue Tourmaline,Neon Blue Tourmaline,Tourmaline Jewellery,Jewellers,Lagoon Colour,Oceangemsminerals,Ink Blue Tourmaline,Rings For Women,bicolour tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('6614306a-fca0-43fd-a83e-82a5d47c25c9', '5.35 Cts Seafoam Tourmaline lot', 'blue tourmaline lot 

Bright colour 

More Beautiful In Real And At very reasonable price 

5.35 Cts
4.9 to 3.9mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 222, 1, 'loose_stone', 'Tourmaline', NULL, 5.35, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/6614306a-fca0-43fd-a83e-82a5d47c25c9/etsy-1.jpg","https://media.gemworkers.com/items/6614306a-fca0-43fd-a83e-82a5d47c25c9/etsy-2.jpg","https://media.gemworkers.com/items/6614306a-fca0-43fd-a83e-82a5d47c25c9/etsy-3.jpg","https://media.gemworkers.com/items/6614306a-fca0-43fd-a83e-82a5d47c25c9/etsy-4.jpg","https://media.gemworkers.com/items/6614306a-fca0-43fd-a83e-82a5d47c25c9/etsy-5.jpg","https://media.gemworkers.com/items/6614306a-fca0-43fd-a83e-82a5d47c25c9/etsy-6.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 249 USD, converted at ECB rate. Etsy tags: Paraiba Tourmaline,Paraiba Colour,Lagoon Tourmaline,Bluegreen Tourmaline,Blue Tourmaline,Neon Blue Tourmaline,Tourmaline Jewellery,Jewellers,Lagoon Colour,Oceangemsminerals,Ink Blue Tourmaline,Rings For Women,bicolour tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('2f73114d-dd47-4ad1-8a4f-4d86777d3068', '19.65 Cts Tricolour Tourmaline Lot', 'To All The Bicolour Lovers Here Is An Incredible Opportunity Buy A Truly Exceptional And One Of A Kind Bicolour And Tricolour Tourmaline Lot

19.65 Cts
13.3 x 8.9 to 10.3 x 5.7mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 268, 1, 'loose_stone', 'Tourmaline', NULL, 19.65, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/2f73114d-dd47-4ad1-8a4f-4d86777d3068/etsy-1.jpg","https://media.gemworkers.com/items/2f73114d-dd47-4ad1-8a4f-4d86777d3068/etsy-2.jpg","https://media.gemworkers.com/items/2f73114d-dd47-4ad1-8a4f-4d86777d3068/etsy-3.jpg","https://media.gemworkers.com/items/2f73114d-dd47-4ad1-8a4f-4d86777d3068/etsy-4.jpg","https://media.gemworkers.com/items/2f73114d-dd47-4ad1-8a4f-4d86777d3068/etsy-5.jpg","https://media.gemworkers.com/items/2f73114d-dd47-4ad1-8a4f-4d86777d3068/etsy-6.jpg","https://media.gemworkers.com/items/2f73114d-dd47-4ad1-8a4f-4d86777d3068/etsy-7.jpg","https://media.gemworkers.com/items/2f73114d-dd47-4ad1-8a4f-4d86777d3068/etsy-8.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 300 USD, converted at ECB rate. Etsy tags: pink tourmaline,rings for women,unique tourmaline,Handmadejewellery,gift for her,Bicolour Tourmaline,Unique Bicolour,Rare Tourmaline,Oceangemsminerals,Tourmaline Pairs,Bicolour Pairs,Canary Tourmaline,Mix Bicolour Lot.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('5c4b9b75-ef14-4f45-8481-b526a00f2d4a', '11.30 Cts  Seafoam Tourmaline lot', 'blue tourmaline lot 

Bright colour 

More Beautiful In Real And At very reasonable price 

11.30 Cts
10 to 7mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 179, 1, 'loose_stone', 'Tourmaline', NULL, 11.3, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/5c4b9b75-ef14-4f45-8481-b526a00f2d4a/etsy-1.jpg","https://media.gemworkers.com/items/5c4b9b75-ef14-4f45-8481-b526a00f2d4a/etsy-2.jpg","https://media.gemworkers.com/items/5c4b9b75-ef14-4f45-8481-b526a00f2d4a/etsy-3.jpg","https://media.gemworkers.com/items/5c4b9b75-ef14-4f45-8481-b526a00f2d4a/etsy-4.jpg","https://media.gemworkers.com/items/5c4b9b75-ef14-4f45-8481-b526a00f2d4a/etsy-5.jpg","https://media.gemworkers.com/items/5c4b9b75-ef14-4f45-8481-b526a00f2d4a/etsy-6.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 200 USD, converted at ECB rate. Etsy tags: Paraiba Tourmaline,Paraiba Colour,Lagoon Tourmaline,Bluegreen Tourmaline,Blue Tourmaline,Neon Blue Tourmaline,Tourmaline Jewellery,Jewellers,Lagoon Colour,Oceangemsminerals,Ink Blue Tourmaline,Rings For Women,bicolour tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('04e0180a-1945-4e4a-8fc1-e1b2511130a1', '10.80 Cts,Rare Bicolour Tourmaline Chrome Green And And Golden Peach,', 'To All The Bicolour Lovers Here Is An Incredible Opportunity Buy A Truly Exceptional And One Of A Kind Bicolour Tourmaline Pairs 

Golden Peach And Chrome Green Colour Combination 

Collection worthy 

10.80 carats 

Smaller pair:7x5x4mm
Longer pair:14x6x5mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 447, 1, 'loose_stone', 'Tourmaline', NULL, 10.8, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/04e0180a-1945-4e4a-8fc1-e1b2511130a1/etsy-1.jpg","https://media.gemworkers.com/items/04e0180a-1945-4e4a-8fc1-e1b2511130a1/etsy-2.jpg","https://media.gemworkers.com/items/04e0180a-1945-4e4a-8fc1-e1b2511130a1/etsy-3.jpg","https://media.gemworkers.com/items/04e0180a-1945-4e4a-8fc1-e1b2511130a1/etsy-4.jpg","https://media.gemworkers.com/items/04e0180a-1945-4e4a-8fc1-e1b2511130a1/etsy-5.jpg","https://media.gemworkers.com/items/04e0180a-1945-4e4a-8fc1-e1b2511130a1/etsy-6.jpg","https://media.gemworkers.com/items/04e0180a-1945-4e4a-8fc1-e1b2511130a1/etsy-7.jpg","https://media.gemworkers.com/items/04e0180a-1945-4e4a-8fc1-e1b2511130a1/etsy-8.jpg","https://media.gemworkers.com/items/04e0180a-1945-4e4a-8fc1-e1b2511130a1/etsy-9.jpg","https://media.gemworkers.com/items/04e0180a-1945-4e4a-8fc1-e1b2511130a1/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 500 USD, converted at ECB rate. Etsy tags: pink tourmaline,rings for women,unique tourmaline,jewels,Handmadejewellery,gift for her,Topqualitytourmaline,Bicolour Tourmaline,Unique Bicolour,Rare Tourmaline,Oceangemsminerals,Tourmaline Pairs,Bicolour Pairs.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('f7ee7830-d1d8-4159-8379-85bb054e76fb', '5.9 Cts Lagoon Tourmaline Lot', 'Gorgeous Top Lagoon Colour Tourmaline Lot

Exceptional Colour Very Rare To Be Find, Bright Colour Not Dull.

More Beautiful In Real.

5.9 Cts
4.7 to 6.1mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 356, 1, 'loose_stone', 'Tourmaline', NULL, 5.9, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/f7ee7830-d1d8-4159-8379-85bb054e76fb/etsy-1.jpg","https://media.gemworkers.com/items/f7ee7830-d1d8-4159-8379-85bb054e76fb/etsy-2.jpg","https://media.gemworkers.com/items/f7ee7830-d1d8-4159-8379-85bb054e76fb/etsy-3.jpg","https://media.gemworkers.com/items/f7ee7830-d1d8-4159-8379-85bb054e76fb/etsy-4.jpg","https://media.gemworkers.com/items/f7ee7830-d1d8-4159-8379-85bb054e76fb/etsy-5.jpg","https://media.gemworkers.com/items/f7ee7830-d1d8-4159-8379-85bb054e76fb/etsy-6.jpg","https://media.gemworkers.com/items/f7ee7830-d1d8-4159-8379-85bb054e76fb/etsy-7.jpg","https://media.gemworkers.com/items/f7ee7830-d1d8-4159-8379-85bb054e76fb/etsy-8.jpg","https://media.gemworkers.com/items/f7ee7830-d1d8-4159-8379-85bb054e76fb/etsy-9.jpg","https://media.gemworkers.com/items/f7ee7830-d1d8-4159-8379-85bb054e76fb/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 399 USD, converted at ECB rate. Etsy tags: Paraiba Tourmaline,Paraiba Colour,Lagoon Tourmaline,Bluegreen Tourmaline,Blue Tourmaline,Neon Blue Tourmaline,Tourmaline Jewellery,Jewellers,Lagoon Colour,Oceangemsminerals,Ink Blue Tourmaline,Wedding Rings,Rings For Women.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('6b3333e3-204e-4f15-b7bb-973a3f994db2', '9.65 Cts blue and Green Tourmaline Lot', 'Blue and Green Afghan Tourmaline Lot 

Cushion Cut.

High Lustre And Good Colours.

9.65 Cts
5.7 to 7.1mm

Unheated,Untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 223, 1, 'loose_stone', 'Tourmaline', NULL, 9.65, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/6b3333e3-204e-4f15-b7bb-973a3f994db2/etsy-1.jpg","https://media.gemworkers.com/items/6b3333e3-204e-4f15-b7bb-973a3f994db2/etsy-2.jpg","https://media.gemworkers.com/items/6b3333e3-204e-4f15-b7bb-973a3f994db2/etsy-3.jpg","https://media.gemworkers.com/items/6b3333e3-204e-4f15-b7bb-973a3f994db2/etsy-4.jpg","https://media.gemworkers.com/items/6b3333e3-204e-4f15-b7bb-973a3f994db2/etsy-5.jpg","https://media.gemworkers.com/items/6b3333e3-204e-4f15-b7bb-973a3f994db2/etsy-6.jpg","https://media.gemworkers.com/items/6b3333e3-204e-4f15-b7bb-973a3f994db2/etsy-7.jpg","https://media.gemworkers.com/items/6b3333e3-204e-4f15-b7bb-973a3f994db2/etsy-8.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 250 USD, converted at ECB rate. Etsy tags: Jewellery Making,Jewellery Supplies,Gemstones Jewellery,Jewellery Findings,Gift for her,Rings For Women,Rings For Men,Gold Rings,Jewels,Bluegreen tourmaline,neon tourmaline,lagoon tourmaline,mintgreentourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('5aabae22-0c0d-44b3-b4fb-1964bd26b395', '7.5 Cts Green Tourmaline Lot', 'Green Afghan Tourmaline Lot

7.5 Cts
4.5 to 6.9mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 214, 1, 'loose_stone', 'Tourmaline', NULL, 7.5, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/5aabae22-0c0d-44b3-b4fb-1964bd26b395/etsy-1.jpg","https://media.gemworkers.com/items/5aabae22-0c0d-44b3-b4fb-1964bd26b395/etsy-2.jpg","https://media.gemworkers.com/items/5aabae22-0c0d-44b3-b4fb-1964bd26b395/etsy-3.jpg","https://media.gemworkers.com/items/5aabae22-0c0d-44b3-b4fb-1964bd26b395/etsy-4.jpg","https://media.gemworkers.com/items/5aabae22-0c0d-44b3-b4fb-1964bd26b395/etsy-5.jpg","https://media.gemworkers.com/items/5aabae22-0c0d-44b3-b4fb-1964bd26b395/etsy-6.jpg","https://media.gemworkers.com/items/5aabae22-0c0d-44b3-b4fb-1964bd26b395/etsy-7.jpg","https://media.gemworkers.com/items/5aabae22-0c0d-44b3-b4fb-1964bd26b395/etsy-8.jpg","https://media.gemworkers.com/items/5aabae22-0c0d-44b3-b4fb-1964bd26b395/etsy-9.jpg","https://media.gemworkers.com/items/5aabae22-0c0d-44b3-b4fb-1964bd26b395/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 240 USD, converted at ECB rate. Etsy tags: Paraiba Tourmaline,Paraiba Colour,Lagoon Tourmaline,Bluegreen Tourmaline,Blue Tourmaline,Neon Blue Tourmaline,Tourmaline Jewellery,Lagoon Colour,Oceangemsminerals,Ink Blue Tourmaline,Wedding Rings,Rings For Women,Cushion Cut.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('23cefcc2-5d8e-4125-a5ba-57d7ef3f266c', '9 Cts blue and Green Tourmaline Lot', 'Blue and Green Afghan Tourmaline Lot 

Cushion Cut.

High Lustre And Good Colours.

9 Cts
5.4 to 18mm

Unheated,Untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 223, 1, 'loose_stone', 'Tourmaline', NULL, 9, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/23cefcc2-5d8e-4125-a5ba-57d7ef3f266c/etsy-1.jpg","https://media.gemworkers.com/items/23cefcc2-5d8e-4125-a5ba-57d7ef3f266c/etsy-2.jpg","https://media.gemworkers.com/items/23cefcc2-5d8e-4125-a5ba-57d7ef3f266c/etsy-3.jpg","https://media.gemworkers.com/items/23cefcc2-5d8e-4125-a5ba-57d7ef3f266c/etsy-4.jpg","https://media.gemworkers.com/items/23cefcc2-5d8e-4125-a5ba-57d7ef3f266c/etsy-5.jpg","https://media.gemworkers.com/items/23cefcc2-5d8e-4125-a5ba-57d7ef3f266c/etsy-6.jpg","https://media.gemworkers.com/items/23cefcc2-5d8e-4125-a5ba-57d7ef3f266c/etsy-7.jpg","https://media.gemworkers.com/items/23cefcc2-5d8e-4125-a5ba-57d7ef3f266c/etsy-8.jpg","https://media.gemworkers.com/items/23cefcc2-5d8e-4125-a5ba-57d7ef3f266c/etsy-9.jpg","https://media.gemworkers.com/items/23cefcc2-5d8e-4125-a5ba-57d7ef3f266c/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 250 USD, converted at ECB rate. Etsy tags: Jewellery Making,Jewellery Supplies,Gemstones Jewellery,Jewellery Findings,Gift for her,Rings For Women,Rings For Men,Gold Rings,Jewels,Bluegreen tourmaline,neon tourmaline,lagoon tourmaline,mintgreentourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('61965776-1d86-4d8a-9f13-149fdfc989d6', '5.7 Cts Lagoon Colour Tourmaline', 'Presenting One Of The Best Colour In Tourmalines

Exceptional Colour Very Rare To Be Find, Bright Colour Not Dull.

More Beautiful In Real. 

5.70 carats
11.4x7.6x6.5mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 535, 1, 'loose_stone', 'Tourmaline', NULL, 5.7, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/61965776-1d86-4d8a-9f13-149fdfc989d6/etsy-1.jpg","https://media.gemworkers.com/items/61965776-1d86-4d8a-9f13-149fdfc989d6/etsy-2.jpg","https://media.gemworkers.com/items/61965776-1d86-4d8a-9f13-149fdfc989d6/etsy-3.jpg","https://media.gemworkers.com/items/61965776-1d86-4d8a-9f13-149fdfc989d6/etsy-4.jpg","https://media.gemworkers.com/items/61965776-1d86-4d8a-9f13-149fdfc989d6/etsy-5.jpg","https://media.gemworkers.com/items/61965776-1d86-4d8a-9f13-149fdfc989d6/etsy-6.jpg","https://media.gemworkers.com/items/61965776-1d86-4d8a-9f13-149fdfc989d6/etsy-7.jpg","https://media.gemworkers.com/items/61965776-1d86-4d8a-9f13-149fdfc989d6/etsy-8.jpg","https://media.gemworkers.com/items/61965776-1d86-4d8a-9f13-149fdfc989d6/etsy-9.jpg","https://media.gemworkers.com/items/61965776-1d86-4d8a-9f13-149fdfc989d6/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 599 USD, converted at ECB rate. Etsy tags: Paraiba Tourmaline,Paraiba Colour,Lagoon Tourmaline,Bluegreen Tourmaline,Blue Tourmaline,Neon Blue Tourmaline,Tourmaline Jewellery,Jewellers,Lagoon Colour,Oceangemsminerals,Ink Blue Tourmaline,Wedding Rings,Rings For Women.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('9488bb53-a2e6-4889-8855-907bf526b7bd', '2.85 Cts Lagoon Colour Tourmaline', 'Presenting One Of The Best Colour In Tourmalines

Exceptional Colour Very Rare To Be Find, Bright Colour Not Dull.

More Beautiful In Real. 

2.85 carats 
9.3x6.6x5mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 356, 1, 'loose_stone', 'Tourmaline', NULL, 2.85, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/9488bb53-a2e6-4889-8855-907bf526b7bd/etsy-1.jpg","https://media.gemworkers.com/items/9488bb53-a2e6-4889-8855-907bf526b7bd/etsy-2.jpg","https://media.gemworkers.com/items/9488bb53-a2e6-4889-8855-907bf526b7bd/etsy-3.jpg","https://media.gemworkers.com/items/9488bb53-a2e6-4889-8855-907bf526b7bd/etsy-4.jpg","https://media.gemworkers.com/items/9488bb53-a2e6-4889-8855-907bf526b7bd/etsy-5.jpg","https://media.gemworkers.com/items/9488bb53-a2e6-4889-8855-907bf526b7bd/etsy-6.jpg","https://media.gemworkers.com/items/9488bb53-a2e6-4889-8855-907bf526b7bd/etsy-7.jpg","https://media.gemworkers.com/items/9488bb53-a2e6-4889-8855-907bf526b7bd/etsy-8.jpg","https://media.gemworkers.com/items/9488bb53-a2e6-4889-8855-907bf526b7bd/etsy-9.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 399 USD, converted at ECB rate. Etsy tags: Paraiba Tourmaline,Paraiba Colour,Lagoon Tourmaline,Bluegreen Tourmaline,Blue Tourmaline,Neon Blue Tourmaline,Tourmaline Jewellery,Jewellers,Lagoon Colour,Oceangemsminerals,Ink Blue Tourmaline,Wedding Rings,Rings For Women.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('a4b397b8-0bbc-418c-bdbd-cb3418ecf2f3', '2.6 Cts Lagoon Colour Tourmaline', 'Presenting One Of The Best Colour In Tourmalines

Exceptional Colour Very Rare To Be Find, Bright Colour Not Dull.

More Beautiful In Real. 

2.60 carats
7.5x7x5.8mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 356, 1, 'loose_stone', 'Tourmaline', NULL, 2.6, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/a4b397b8-0bbc-418c-bdbd-cb3418ecf2f3/etsy-1.jpg","https://media.gemworkers.com/items/a4b397b8-0bbc-418c-bdbd-cb3418ecf2f3/etsy-2.jpg","https://media.gemworkers.com/items/a4b397b8-0bbc-418c-bdbd-cb3418ecf2f3/etsy-3.jpg","https://media.gemworkers.com/items/a4b397b8-0bbc-418c-bdbd-cb3418ecf2f3/etsy-4.jpg","https://media.gemworkers.com/items/a4b397b8-0bbc-418c-bdbd-cb3418ecf2f3/etsy-5.jpg","https://media.gemworkers.com/items/a4b397b8-0bbc-418c-bdbd-cb3418ecf2f3/etsy-6.jpg","https://media.gemworkers.com/items/a4b397b8-0bbc-418c-bdbd-cb3418ecf2f3/etsy-7.jpg","https://media.gemworkers.com/items/a4b397b8-0bbc-418c-bdbd-cb3418ecf2f3/etsy-8.jpg","https://media.gemworkers.com/items/a4b397b8-0bbc-418c-bdbd-cb3418ecf2f3/etsy-9.jpg","https://media.gemworkers.com/items/a4b397b8-0bbc-418c-bdbd-cb3418ecf2f3/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 399 USD, converted at ECB rate. Etsy tags: Paraiba Tourmaline,Paraiba Colour,Lagoon Tourmaline,Bluegreen Tourmaline,Blue Tourmaline,Neon Blue Tourmaline,Tourmaline Jewellery,Jewellers,Lagoon Colour,Oceangemsminerals,Ink Blue Tourmaline,Wedding Rings,Rings For Women.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('7949afab-8860-4065-92f1-7e05641f5da3', '2 Cts Vibrant Green Tourmaline', 'Beautiful Top Green Afghan Tourmaline

Vibrant Colour

Perfectly Cut

2 carats
7.4x6.2x5.2mm

Unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 267, 1, 'loose_stone', 'Tourmaline', NULL, 2, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/7949afab-8860-4065-92f1-7e05641f5da3/etsy-1.jpg","https://media.gemworkers.com/items/7949afab-8860-4065-92f1-7e05641f5da3/etsy-2.jpg","https://media.gemworkers.com/items/7949afab-8860-4065-92f1-7e05641f5da3/etsy-3.jpg","https://media.gemworkers.com/items/7949afab-8860-4065-92f1-7e05641f5da3/etsy-4.jpg","https://media.gemworkers.com/items/7949afab-8860-4065-92f1-7e05641f5da3/etsy-5.jpg","https://media.gemworkers.com/items/7949afab-8860-4065-92f1-7e05641f5da3/etsy-6.jpg","https://media.gemworkers.com/items/7949afab-8860-4065-92f1-7e05641f5da3/etsy-7.jpg","https://media.gemworkers.com/items/7949afab-8860-4065-92f1-7e05641f5da3/etsy-8.jpg","https://media.gemworkers.com/items/7949afab-8860-4065-92f1-7e05641f5da3/etsy-9.jpg","https://media.gemworkers.com/items/7949afab-8860-4065-92f1-7e05641f5da3/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 299 USD, converted at ECB rate. Etsy tags: Green Tourmaline,Vibrant Tourmaline,AppleGreenTourmaline,Tourmaline jewellery,jewellers,jewellery making,jewellery supplies,jewellery findings,Oceangemsminerals,rings for women,rings for men,rings jewellery,natural stone.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('e83f9783-f813-46af-879f-c0921b6a638c', '5 Cts Ink Blue Tourmaline', 'Gorgeous Mesmerising Rare Ink Blue Colour Afghan Tourmaline 

Open Colour, Exceptional piece

5 carats 
8.8x8.3x7mm

unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 312, 1, 'loose_stone', 'Tourmaline', NULL, 5, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/e83f9783-f813-46af-879f-c0921b6a638c/etsy-1.jpg","https://media.gemworkers.com/items/e83f9783-f813-46af-879f-c0921b6a638c/etsy-2.jpg","https://media.gemworkers.com/items/e83f9783-f813-46af-879f-c0921b6a638c/etsy-3.jpg","https://media.gemworkers.com/items/e83f9783-f813-46af-879f-c0921b6a638c/etsy-4.jpg","https://media.gemworkers.com/items/e83f9783-f813-46af-879f-c0921b6a638c/etsy-5.jpg","https://media.gemworkers.com/items/e83f9783-f813-46af-879f-c0921b6a638c/etsy-6.jpg","https://media.gemworkers.com/items/e83f9783-f813-46af-879f-c0921b6a638c/etsy-7.jpg","https://media.gemworkers.com/items/e83f9783-f813-46af-879f-c0921b6a638c/etsy-8.jpg","https://media.gemworkers.com/items/e83f9783-f813-46af-879f-c0921b6a638c/etsy-9.jpg","https://media.gemworkers.com/items/e83f9783-f813-46af-879f-c0921b6a638c/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 349 USD, converted at ECB rate. Etsy tags: Gold Rings,Rings For Men,Rings For Women,Tourmaline Jewellery,Natural Stone,bicolour Tourmaline,Lagoon tourmaline,Bluegreen tourmaline,blue tourmaline,indigo tourmaline,Oceangemsminerals,rare tourmaline,ink blue tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('2b96d3b0-2cf0-47f6-b70c-eadbb4c5d0bf', '3.4 Cts Ink Blue Tourmaline', 'Gorgeous Mesmerising Rare Ink Blue Colour Afghan Tourmaline 

Open Colour, Exceptional piece

3.40 carats
9.4x6.9x5.9mm

unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 304, 1, 'loose_stone', 'Tourmaline', NULL, 3.4, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/2b96d3b0-2cf0-47f6-b70c-eadbb4c5d0bf/etsy-1.jpg","https://media.gemworkers.com/items/2b96d3b0-2cf0-47f6-b70c-eadbb4c5d0bf/etsy-2.jpg","https://media.gemworkers.com/items/2b96d3b0-2cf0-47f6-b70c-eadbb4c5d0bf/etsy-3.jpg","https://media.gemworkers.com/items/2b96d3b0-2cf0-47f6-b70c-eadbb4c5d0bf/etsy-4.jpg","https://media.gemworkers.com/items/2b96d3b0-2cf0-47f6-b70c-eadbb4c5d0bf/etsy-5.jpg","https://media.gemworkers.com/items/2b96d3b0-2cf0-47f6-b70c-eadbb4c5d0bf/etsy-6.jpg","https://media.gemworkers.com/items/2b96d3b0-2cf0-47f6-b70c-eadbb4c5d0bf/etsy-7.jpg","https://media.gemworkers.com/items/2b96d3b0-2cf0-47f6-b70c-eadbb4c5d0bf/etsy-8.jpg","https://media.gemworkers.com/items/2b96d3b0-2cf0-47f6-b70c-eadbb4c5d0bf/etsy-9.jpg","https://media.gemworkers.com/items/2b96d3b0-2cf0-47f6-b70c-eadbb4c5d0bf/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 340 USD, converted at ECB rate. Etsy tags: Gold Rings,Rings For Men,Rings For Women,Tourmaline Jewellery,Natural Stone,bicolour Tourmaline,Lagoon tourmaline,Bluegreen tourmaline,blue tourmaline,indigo tourmaline,Oceangemsminerals,rare tourmaline,ink blue tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('a222449c-9f5d-4aeb-bdea-b4176bef5b5a', '4 Cts Blue Green Tourmaline', 'Top Quality Blue Green Tourmaline 

Glossy And High Lustre

4 carats 
8.1x7.7x6.6mm

Unheated, No treatment Whatsoever.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 178, 1, 'loose_stone', 'Tourmaline', NULL, 4, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/a222449c-9f5d-4aeb-bdea-b4176bef5b5a/etsy-1.jpg","https://media.gemworkers.com/items/a222449c-9f5d-4aeb-bdea-b4176bef5b5a/etsy-2.jpg","https://media.gemworkers.com/items/a222449c-9f5d-4aeb-bdea-b4176bef5b5a/etsy-3.jpg","https://media.gemworkers.com/items/a222449c-9f5d-4aeb-bdea-b4176bef5b5a/etsy-4.jpg","https://media.gemworkers.com/items/a222449c-9f5d-4aeb-bdea-b4176bef5b5a/etsy-5.jpg","https://media.gemworkers.com/items/a222449c-9f5d-4aeb-bdea-b4176bef5b5a/etsy-6.jpg","https://media.gemworkers.com/items/a222449c-9f5d-4aeb-bdea-b4176bef5b5a/etsy-7.jpg","https://media.gemworkers.com/items/a222449c-9f5d-4aeb-bdea-b4176bef5b5a/etsy-8.jpg","https://media.gemworkers.com/items/a222449c-9f5d-4aeb-bdea-b4176bef5b5a/etsy-9.jpg","https://media.gemworkers.com/items/a222449c-9f5d-4aeb-bdea-b4176bef5b5a/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 199 USD, converted at ECB rate. Etsy tags: Jewellery Making,Rings For Women,Rings For Men,Gold Rings,Jewellery Supplies,Gift For Her,Natural Stone,Bluegreen Tourmaline,Blue tourmaline,lagoon Tourmaline,MintGreen Tourmaline,Oceangemsminerals,Green Tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('6cd32ebe-bf22-480e-bc99-67a258196dc0', '3.9 Cts Ink Blue Tourmaline', 'Ink Blue Colour Tourmaline 

rare find

3.90 carats 
8.8x8.3x6.7mm

No Treatment Whatsoever.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 178, 1, 'loose_stone', 'Tourmaline', NULL, 3.9, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/6cd32ebe-bf22-480e-bc99-67a258196dc0/etsy-1.jpg","https://media.gemworkers.com/items/6cd32ebe-bf22-480e-bc99-67a258196dc0/etsy-2.jpg","https://media.gemworkers.com/items/6cd32ebe-bf22-480e-bc99-67a258196dc0/etsy-3.jpg","https://media.gemworkers.com/items/6cd32ebe-bf22-480e-bc99-67a258196dc0/etsy-4.jpg","https://media.gemworkers.com/items/6cd32ebe-bf22-480e-bc99-67a258196dc0/etsy-5.jpg","https://media.gemworkers.com/items/6cd32ebe-bf22-480e-bc99-67a258196dc0/etsy-6.jpg","https://media.gemworkers.com/items/6cd32ebe-bf22-480e-bc99-67a258196dc0/etsy-7.jpg","https://media.gemworkers.com/items/6cd32ebe-bf22-480e-bc99-67a258196dc0/etsy-8.jpg","https://media.gemworkers.com/items/6cd32ebe-bf22-480e-bc99-67a258196dc0/etsy-9.jpg","https://media.gemworkers.com/items/6cd32ebe-bf22-480e-bc99-67a258196dc0/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 199 USD, converted at ECB rate. Etsy tags: Emerald Cut,EmeraldCutTourmaline,Jewellery making,earrings stud,Tourmaline Lot,Blue Tourmaline,Lagoon Tourmaline,Neon Blue,neon blue tourmaline,Rings For Men,Tourmalines,Ink Blue Tourmaline,Oceangemsminerals.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('3fd78c84-b468-4952-9bf3-110855de26c9', '6.9 Cts Blue And Green Tourmaline', 'Gorgeous Mesmerising Blue And Green Afghan Tourmaline 

Unique Colour, Sugar Inclusions 

6.90 carats 
9.2x7.9x6.7mm 
7.8x7.1x5.9mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 356, 1, 'loose_stone', 'Tourmaline', NULL, 6.9, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/3fd78c84-b468-4952-9bf3-110855de26c9/etsy-1.jpg","https://media.gemworkers.com/items/3fd78c84-b468-4952-9bf3-110855de26c9/etsy-2.jpg","https://media.gemworkers.com/items/3fd78c84-b468-4952-9bf3-110855de26c9/etsy-3.jpg","https://media.gemworkers.com/items/3fd78c84-b468-4952-9bf3-110855de26c9/etsy-4.jpg","https://media.gemworkers.com/items/3fd78c84-b468-4952-9bf3-110855de26c9/etsy-5.jpg","https://media.gemworkers.com/items/3fd78c84-b468-4952-9bf3-110855de26c9/etsy-6.jpg","https://media.gemworkers.com/items/3fd78c84-b468-4952-9bf3-110855de26c9/etsy-7.jpg","https://media.gemworkers.com/items/3fd78c84-b468-4952-9bf3-110855de26c9/etsy-8.jpg","https://media.gemworkers.com/items/3fd78c84-b468-4952-9bf3-110855de26c9/etsy-9.jpg","https://media.gemworkers.com/items/3fd78c84-b468-4952-9bf3-110855de26c9/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 399 USD, converted at ECB rate. Etsy tags: BlueGreen Tourmaline,Blue Tourmaline,Green Tourmaline,Lagoon Tourmaline,Neon Tourmaline,Tourmaline Rings,rings for women,rings for men,jewellery making,jewellery supplies,jewellery findings,gift for her,natural stone.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('a5495006-e999-4240-b28a-9cfccfe305c0', '6.85 Cts Green Tourmalines', 'Gorgeous Mesmerising Blue Green Afghan Tourmaline 

Unique Colour, Sugar Inclusions 

6.85 carats 
9.7x7.8x7.3mm 
6.8x6.8x5.1mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 313, 1, 'loose_stone', 'Tourmaline', NULL, 6.85, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/a5495006-e999-4240-b28a-9cfccfe305c0/etsy-1.jpg","https://media.gemworkers.com/items/a5495006-e999-4240-b28a-9cfccfe305c0/etsy-2.jpg","https://media.gemworkers.com/items/a5495006-e999-4240-b28a-9cfccfe305c0/etsy-3.jpg","https://media.gemworkers.com/items/a5495006-e999-4240-b28a-9cfccfe305c0/etsy-4.jpg","https://media.gemworkers.com/items/a5495006-e999-4240-b28a-9cfccfe305c0/etsy-5.jpg","https://media.gemworkers.com/items/a5495006-e999-4240-b28a-9cfccfe305c0/etsy-6.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 350 USD, converted at ECB rate. Etsy tags: BlueGreen Tourmaline,Blue Tourmaline,Green Tourmaline,Lagoon Tourmaline,Neon Tourmaline,Tourmaline Rings,rings for women,rings for men,jewellery making,jewellery supplies,jewellery findings,gift for her,natural stone.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('96bab8e8-9694-4e11-9add-2abe5fa37158', '12.5 Cts Green Tourmalines', 'Gorgeous Mesmerising Blue Green Afghan Tourmaline 

Unique Colour 

12.55 carats 
12x7.8x9mm 
9.1x8.9x6.5mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 268, 1, 'loose_stone', 'Tourmaline', NULL, 12.5, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/96bab8e8-9694-4e11-9add-2abe5fa37158/etsy-1.jpg","https://media.gemworkers.com/items/96bab8e8-9694-4e11-9add-2abe5fa37158/etsy-2.jpg","https://media.gemworkers.com/items/96bab8e8-9694-4e11-9add-2abe5fa37158/etsy-3.jpg","https://media.gemworkers.com/items/96bab8e8-9694-4e11-9add-2abe5fa37158/etsy-4.jpg","https://media.gemworkers.com/items/96bab8e8-9694-4e11-9add-2abe5fa37158/etsy-5.jpg","https://media.gemworkers.com/items/96bab8e8-9694-4e11-9add-2abe5fa37158/etsy-6.jpg","https://media.gemworkers.com/items/96bab8e8-9694-4e11-9add-2abe5fa37158/etsy-7.jpg","https://media.gemworkers.com/items/96bab8e8-9694-4e11-9add-2abe5fa37158/etsy-8.jpg","https://media.gemworkers.com/items/96bab8e8-9694-4e11-9add-2abe5fa37158/etsy-9.jpg","https://media.gemworkers.com/items/96bab8e8-9694-4e11-9add-2abe5fa37158/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 300 USD, converted at ECB rate. Etsy tags: BlueGreen Tourmaline,Blue Tourmaline,Green Tourmaline,Lagoon Tourmaline,Neon Tourmaline,Tourmaline Rings,rings for women,rings for men,jewellery making,jewellery supplies,jewellery findings,gift for her,natural stone.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('7aebfb4f-6bff-4f99-a16f-9e5f7e39ad07', '11.9 Cts Green Tourmalines', 'Gorgeous Mesmerising Blue Green Afghan Tourmaline 

Unique Colour 

11.90 carats 
9.1x8.7x6.7mm 
8.5x8.4x6.2mm
8.4x6.4x5.9mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 197, 1, 'loose_stone', 'Tourmaline', NULL, 11.9, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/7aebfb4f-6bff-4f99-a16f-9e5f7e39ad07/etsy-1.jpg","https://media.gemworkers.com/items/7aebfb4f-6bff-4f99-a16f-9e5f7e39ad07/etsy-2.jpg","https://media.gemworkers.com/items/7aebfb4f-6bff-4f99-a16f-9e5f7e39ad07/etsy-3.jpg","https://media.gemworkers.com/items/7aebfb4f-6bff-4f99-a16f-9e5f7e39ad07/etsy-4.jpg","https://media.gemworkers.com/items/7aebfb4f-6bff-4f99-a16f-9e5f7e39ad07/etsy-5.jpg","https://media.gemworkers.com/items/7aebfb4f-6bff-4f99-a16f-9e5f7e39ad07/etsy-6.jpg","https://media.gemworkers.com/items/7aebfb4f-6bff-4f99-a16f-9e5f7e39ad07/etsy-7.jpg","https://media.gemworkers.com/items/7aebfb4f-6bff-4f99-a16f-9e5f7e39ad07/etsy-8.jpg","https://media.gemworkers.com/items/7aebfb4f-6bff-4f99-a16f-9e5f7e39ad07/etsy-9.jpg","https://media.gemworkers.com/items/7aebfb4f-6bff-4f99-a16f-9e5f7e39ad07/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 220 USD, converted at ECB rate. Etsy tags: BlueGreen Tourmaline,Blue Tourmaline,Green Tourmaline,Lagoon Tourmaline,Neon Tourmaline,Tourmaline Rings,rings for women,rings for men,jewellery making,jewellery supplies,jewellery findings,gift for her,natural stone.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('c991a2d5-00f1-4c64-a722-8e4a842cfe73', '1.1 Cts, Apple Green Tourmaline', 'Mesmerising Mint Green Colour Afghan Tourmaline 

Ethically Sourced

high lustre 

1.10 carats 
6.3x5.8x4.2mm

Unheated, No treatment Whatsoever.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 98, 1, 'loose_stone', 'Tourmaline', NULL, 1.1, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/c991a2d5-00f1-4c64-a722-8e4a842cfe73/etsy-1.jpg","https://media.gemworkers.com/items/c991a2d5-00f1-4c64-a722-8e4a842cfe73/etsy-2.jpg","https://media.gemworkers.com/items/c991a2d5-00f1-4c64-a722-8e4a842cfe73/etsy-3.jpg","https://media.gemworkers.com/items/c991a2d5-00f1-4c64-a722-8e4a842cfe73/etsy-4.jpg","https://media.gemworkers.com/items/c991a2d5-00f1-4c64-a722-8e4a842cfe73/etsy-5.jpg","https://media.gemworkers.com/items/c991a2d5-00f1-4c64-a722-8e4a842cfe73/etsy-6.jpg","https://media.gemworkers.com/items/c991a2d5-00f1-4c64-a722-8e4a842cfe73/etsy-7.jpg","https://media.gemworkers.com/items/c991a2d5-00f1-4c64-a722-8e4a842cfe73/etsy-8.jpg","https://media.gemworkers.com/items/c991a2d5-00f1-4c64-a722-8e4a842cfe73/etsy-9.jpg","https://media.gemworkers.com/items/c991a2d5-00f1-4c64-a722-8e4a842cfe73/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 110 USD, converted at ECB rate. Etsy tags: Jewellery Making,Rings For Women,Jewellery Finding,Rings For Men,Jewels,Gold Rings,Jewellery Supplies,Gift For Her,Natural Stone,Blue tourmaline,lagoon Tourmaline,Oceangemsminerals,AppleGreenTourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('85754d17-d740-484e-8689-26fd8cbbf45d', '2.40 Cts, Blue Green Tourmaline', 'Gorgeous Mesmerising Blue Green Afghan Tourmaline 

Unique Colour 

2.40 Cts
9 x 6 x 5.5mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 165, 1, 'loose_stone', 'Tourmaline', NULL, 2.4, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/85754d17-d740-484e-8689-26fd8cbbf45d/etsy-1.jpg","https://media.gemworkers.com/items/85754d17-d740-484e-8689-26fd8cbbf45d/etsy-2.jpg","https://media.gemworkers.com/items/85754d17-d740-484e-8689-26fd8cbbf45d/etsy-3.jpg","https://media.gemworkers.com/items/85754d17-d740-484e-8689-26fd8cbbf45d/etsy-4.jpg","https://media.gemworkers.com/items/85754d17-d740-484e-8689-26fd8cbbf45d/etsy-5.jpg","https://media.gemworkers.com/items/85754d17-d740-484e-8689-26fd8cbbf45d/etsy-6.jpg","https://media.gemworkers.com/items/85754d17-d740-484e-8689-26fd8cbbf45d/etsy-7.jpg","https://media.gemworkers.com/items/85754d17-d740-484e-8689-26fd8cbbf45d/etsy-8.jpg","https://media.gemworkers.com/items/85754d17-d740-484e-8689-26fd8cbbf45d/etsy-9.jpg","https://media.gemworkers.com/items/85754d17-d740-484e-8689-26fd8cbbf45d/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 185 USD, converted at ECB rate. Etsy tags: BlueGreen Tourmaline,Blue Tourmaline,Green Tourmaline,Lagoon Tourmaline,Neon Tourmaline,Tourmaline Rings,rings for women,rings for men,jewellery making,jewellery supplies,jewellery findings,gift for her,natural stone.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('1ed9c5c2-d045-4057-bb07-9b992053544d', '10 Cts  blue Tourmaline lot', 'blue tourmaline lot 

Bright colour 

More Beautiful In Real And At very reasonable price 

10 Cts
5.5 to 8.5mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 286, 1, 'loose_stone', 'Tourmaline', NULL, 10, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/1ed9c5c2-d045-4057-bb07-9b992053544d/etsy-1.jpg","https://media.gemworkers.com/items/1ed9c5c2-d045-4057-bb07-9b992053544d/etsy-2.jpg","https://media.gemworkers.com/items/1ed9c5c2-d045-4057-bb07-9b992053544d/etsy-3.jpg","https://media.gemworkers.com/items/1ed9c5c2-d045-4057-bb07-9b992053544d/etsy-4.jpg","https://media.gemworkers.com/items/1ed9c5c2-d045-4057-bb07-9b992053544d/etsy-5.jpg","https://media.gemworkers.com/items/1ed9c5c2-d045-4057-bb07-9b992053544d/etsy-6.jpg","https://media.gemworkers.com/items/1ed9c5c2-d045-4057-bb07-9b992053544d/etsy-7.jpg","https://media.gemworkers.com/items/1ed9c5c2-d045-4057-bb07-9b992053544d/etsy-8.jpg","https://media.gemworkers.com/items/1ed9c5c2-d045-4057-bb07-9b992053544d/etsy-9.jpg","https://media.gemworkers.com/items/1ed9c5c2-d045-4057-bb07-9b992053544d/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 320 USD, converted at ECB rate. Etsy tags: Paraiba Tourmaline,Paraiba Colour,Lagoon Tourmaline,Bluegreen Tourmaline,Blue Tourmaline,Neon Blue Tourmaline,Tourmaline Jewellery,Jewellers,Lagoon Colour,Oceangemsminerals,Ink Blue Tourmaline,Rings For Women,bicolour tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('b87fe5e9-5009-4a7c-ad32-c8a88ffebd1f', '5.90 Cts Green Tourmaline', 'Gorgeous Unique Colour Tourmaline 

it can be called blue green also

5.90 Cts

Unheated, No treatment Whatsoever.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 143, 1, 'loose_stone', 'Tourmaline', NULL, 5.9, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/b87fe5e9-5009-4a7c-ad32-c8a88ffebd1f/etsy-1.jpg","https://media.gemworkers.com/items/b87fe5e9-5009-4a7c-ad32-c8a88ffebd1f/etsy-2.jpg","https://media.gemworkers.com/items/b87fe5e9-5009-4a7c-ad32-c8a88ffebd1f/etsy-3.jpg","https://media.gemworkers.com/items/b87fe5e9-5009-4a7c-ad32-c8a88ffebd1f/etsy-4.jpg","https://media.gemworkers.com/items/b87fe5e9-5009-4a7c-ad32-c8a88ffebd1f/etsy-5.jpg","https://media.gemworkers.com/items/b87fe5e9-5009-4a7c-ad32-c8a88ffebd1f/etsy-6.jpg","https://media.gemworkers.com/items/b87fe5e9-5009-4a7c-ad32-c8a88ffebd1f/etsy-7.jpg","https://media.gemworkers.com/items/b87fe5e9-5009-4a7c-ad32-c8a88ffebd1f/etsy-8.jpg","https://media.gemworkers.com/items/b87fe5e9-5009-4a7c-ad32-c8a88ffebd1f/etsy-9.jpg","https://media.gemworkers.com/items/b87fe5e9-5009-4a7c-ad32-c8a88ffebd1f/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 160 USD, converted at ECB rate. Etsy tags: Jewellery Making,Rings For Women,Rings For Men,Jewels,Gold Rings,Jewellery Supplies,Gift For Her,Natural Stone,Bluegreen Tourmaline,Blue tourmaline,lagoon Tourmaline,MintGreen Tourmaline,Oceangemsminerals.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('3d6af401-52a6-44e0-9db6-0a83c4fa6499', '0.9 Cts Hot Pink Tourmaline Pair', 'Gorgeous Hot Pink Tourmaline Pair

Loupe Clean

0.90 Cts
4.5 x 3.5mm

Unheated, Untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 286, 1, 'loose_stone', 'Tourmaline', NULL, 0.9, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/3d6af401-52a6-44e0-9db6-0a83c4fa6499/etsy-1.jpg","https://media.gemworkers.com/items/3d6af401-52a6-44e0-9db6-0a83c4fa6499/etsy-2.jpg","https://media.gemworkers.com/items/3d6af401-52a6-44e0-9db6-0a83c4fa6499/etsy-3.jpg","https://media.gemworkers.com/items/3d6af401-52a6-44e0-9db6-0a83c4fa6499/etsy-4.jpg","https://media.gemworkers.com/items/3d6af401-52a6-44e0-9db6-0a83c4fa6499/etsy-5.jpg","https://media.gemworkers.com/items/3d6af401-52a6-44e0-9db6-0a83c4fa6499/etsy-6.jpg","https://media.gemworkers.com/items/3d6af401-52a6-44e0-9db6-0a83c4fa6499/etsy-7.jpg","https://media.gemworkers.com/items/3d6af401-52a6-44e0-9db6-0a83c4fa6499/etsy-8.jpg","https://media.gemworkers.com/items/3d6af401-52a6-44e0-9db6-0a83c4fa6499/etsy-9.jpg","https://media.gemworkers.com/items/3d6af401-52a6-44e0-9db6-0a83c4fa6499/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 320 USD, converted at ECB rate. Etsy tags: Rings For Men,Rings For Women,Jewellery Stud,Tourmaline Rings,Gift For Her,Gold rings,Natural Stone,Handmade,Oceangemsminerals,Unique Tourmaline,Rare Tourmaline,Pink Tourmaline Lot,Tourmaline Pair.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('a4ef373e-71c1-48ed-864b-b362758e0ea3', '1.65 Cts Watermelon Bicolour Tourmaline', 'Sweet Bicolour Tourmaline 

Unique And Rare Colour

1.65 Cts
13 x 4.4 x 2.9mm

No treatment.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 179, 1, 'loose_stone', 'Tourmaline', 'Watermelon', 1.65, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/a4ef373e-71c1-48ed-864b-b362758e0ea3/etsy-1.jpg","https://media.gemworkers.com/items/a4ef373e-71c1-48ed-864b-b362758e0ea3/etsy-2.jpg","https://media.gemworkers.com/items/a4ef373e-71c1-48ed-864b-b362758e0ea3/etsy-3.jpg","https://media.gemworkers.com/items/a4ef373e-71c1-48ed-864b-b362758e0ea3/etsy-4.jpg","https://media.gemworkers.com/items/a4ef373e-71c1-48ed-864b-b362758e0ea3/etsy-5.jpg","https://media.gemworkers.com/items/a4ef373e-71c1-48ed-864b-b362758e0ea3/etsy-6.jpg","https://media.gemworkers.com/items/a4ef373e-71c1-48ed-864b-b362758e0ea3/etsy-7.jpg","https://media.gemworkers.com/items/a4ef373e-71c1-48ed-864b-b362758e0ea3/etsy-8.jpg","https://media.gemworkers.com/items/a4ef373e-71c1-48ed-864b-b362758e0ea3/etsy-9.jpg","https://media.gemworkers.com/items/a4ef373e-71c1-48ed-864b-b362758e0ea3/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 200 USD, converted at ECB rate. Etsy tags: Tourmaline Jewellery,Tourmaline Earrings,Earrings Stud,y2k earrings stud,Gold Rings,Natural Stone,Gift For Her,Rings For Men,Oceangemsminerals,lagoon tourmaline,tourmaline pairs,bicolour tourmaline,Watermelon Bicolour.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('3e262440-88fe-4a6e-b210-614fed3e4d0d', '2.60 Cts Reverse Pink Tourmaline Pair', 'Gorgeous Unique Reverse Tourmaline Pair

Pink and Whitish Pink

2.60 Cts
6.3 x 6 x 4.7mm

Unheated, Untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 357, 1, 'loose_stone', 'Tourmaline', NULL, 2.6, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/3e262440-88fe-4a6e-b210-614fed3e4d0d/etsy-1.jpg","https://media.gemworkers.com/items/3e262440-88fe-4a6e-b210-614fed3e4d0d/etsy-2.jpg","https://media.gemworkers.com/items/3e262440-88fe-4a6e-b210-614fed3e4d0d/etsy-3.jpg","https://media.gemworkers.com/items/3e262440-88fe-4a6e-b210-614fed3e4d0d/etsy-4.jpg","https://media.gemworkers.com/items/3e262440-88fe-4a6e-b210-614fed3e4d0d/etsy-5.jpg","https://media.gemworkers.com/items/3e262440-88fe-4a6e-b210-614fed3e4d0d/etsy-6.jpg","https://media.gemworkers.com/items/3e262440-88fe-4a6e-b210-614fed3e4d0d/etsy-7.jpg","https://media.gemworkers.com/items/3e262440-88fe-4a6e-b210-614fed3e4d0d/etsy-8.jpg","https://media.gemworkers.com/items/3e262440-88fe-4a6e-b210-614fed3e4d0d/etsy-9.jpg","https://media.gemworkers.com/items/3e262440-88fe-4a6e-b210-614fed3e4d0d/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 400 USD, converted at ECB rate. Etsy tags: Rings For Men,Rings For Women,Jewellery Stud,Tourmaline Rings,Gift For Her,Gold rings,Natural Stone,Handmade,Oceangemsminerals,Unique Tourmaline,Rare Tourmaline,Pink Tourmaline Lot,Tourmaline Pair.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('3d2a8479-b944-4769-b841-327776ed95e6', '4.05 Cts, Natural Bicolour Afghan Tourmalines', 'Gorgeous Mesmerising Natural Bicolour Afghan Tourmalines

Saturated Colour.

4.05 Cts
9.6 x 6 x 4mm
10.4 x 4.5 x 3.3mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 179, 1, 'loose_stone', 'Tourmaline', NULL, 4.05, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/3d2a8479-b944-4769-b841-327776ed95e6/etsy-1.jpg","https://media.gemworkers.com/items/3d2a8479-b944-4769-b841-327776ed95e6/etsy-2.jpg","https://media.gemworkers.com/items/3d2a8479-b944-4769-b841-327776ed95e6/etsy-3.jpg","https://media.gemworkers.com/items/3d2a8479-b944-4769-b841-327776ed95e6/etsy-4.jpg","https://media.gemworkers.com/items/3d2a8479-b944-4769-b841-327776ed95e6/etsy-5.jpg","https://media.gemworkers.com/items/3d2a8479-b944-4769-b841-327776ed95e6/etsy-6.jpg","https://media.gemworkers.com/items/3d2a8479-b944-4769-b841-327776ed95e6/etsy-7.jpg","https://media.gemworkers.com/items/3d2a8479-b944-4769-b841-327776ed95e6/etsy-8.jpg","https://media.gemworkers.com/items/3d2a8479-b944-4769-b841-327776ed95e6/etsy-9.jpg","https://media.gemworkers.com/items/3d2a8479-b944-4769-b841-327776ed95e6/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 200 USD, converted at ECB rate. Etsy tags: Tourmaline Rings,rings for women,rings for men,jewellery making,jewellery findings,gift for her,natural stone,Oceangemsminerals,apple green colour,Bicolour Tourmaline,Natural Bicolour,Unheated Tourmaline,Lipstick Tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('cd2a1e2a-5d6a-485b-aa7a-3c3ca150af9f', '3.40 Cts Round Tourmalines', 'Gorgeous Colour Tourmalines, Three Stones Are Of A Similar Size Can Be Used As A Set

Loupe Clean, And Eye Clean

3.40 Cts
6.6 x 6.6 x 4.8mm
5.4 x 5.4 x 3.9mm

round cut, lustre and brilliance.

No treatment.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 304, 1, 'loose_stone', 'Tourmaline', NULL, 3.4, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/cd2a1e2a-5d6a-485b-aa7a-3c3ca150af9f/etsy-1.jpg","https://media.gemworkers.com/items/cd2a1e2a-5d6a-485b-aa7a-3c3ca150af9f/etsy-2.jpg","https://media.gemworkers.com/items/cd2a1e2a-5d6a-485b-aa7a-3c3ca150af9f/etsy-3.jpg","https://media.gemworkers.com/items/cd2a1e2a-5d6a-485b-aa7a-3c3ca150af9f/etsy-4.jpg","https://media.gemworkers.com/items/cd2a1e2a-5d6a-485b-aa7a-3c3ca150af9f/etsy-5.jpg","https://media.gemworkers.com/items/cd2a1e2a-5d6a-485b-aa7a-3c3ca150af9f/etsy-6.jpg","https://media.gemworkers.com/items/cd2a1e2a-5d6a-485b-aa7a-3c3ca150af9f/etsy-7.jpg","https://media.gemworkers.com/items/cd2a1e2a-5d6a-485b-aa7a-3c3ca150af9f/etsy-8.jpg","https://media.gemworkers.com/items/cd2a1e2a-5d6a-485b-aa7a-3c3ca150af9f/etsy-9.jpg","https://media.gemworkers.com/items/cd2a1e2a-5d6a-485b-aa7a-3c3ca150af9f/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 340 USD, converted at ECB rate. Etsy tags: Loose gemstones,jewellery making,jewellery findings,gift for her,natural stone,y2k earrings stud,jewels,Handmadejewellery,CalibratedTourmaline,Tourmaline Jewellery,Jewellery Size,Tourmaline Lot,mix tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('52dacb32-702e-45ad-8fdc-303c23836458', '22 Cts Aquamarine Cabochon', 'A Very Unique Colour Aquamarine Cabochon 

22+ Cts
34 x 14 x 7mm', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 98, 1, 'loose_stone', 'Aquamarine', NULL, 22, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/52dacb32-702e-45ad-8fdc-303c23836458/etsy-1.jpg","https://media.gemworkers.com/items/52dacb32-702e-45ad-8fdc-303c23836458/etsy-2.jpg","https://media.gemworkers.com/items/52dacb32-702e-45ad-8fdc-303c23836458/etsy-3.jpg","https://media.gemworkers.com/items/52dacb32-702e-45ad-8fdc-303c23836458/etsy-4.jpg","https://media.gemworkers.com/items/52dacb32-702e-45ad-8fdc-303c23836458/etsy-5.jpg","https://media.gemworkers.com/items/52dacb32-702e-45ad-8fdc-303c23836458/etsy-6.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 110 USD, converted at ECB rate. Etsy tags: Santa Maria Cabochon,Blue Aquamarine,Unique Aquamarine,Rare Aquamarine,Aquamarine Cabochons,Bicolour Aquamarine,Bicolour Cabochons,Blue Cabochons,Lagoon Cabochons,Natural Stone,jewels,Oceangemsminerals,Rare Cabochons.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('02b97602-71f6-4b46-a537-fcee6835c105', '40+ Cts Aquamarine Cabochons', 'A Very Unique Colour Aquamarine From Africa

Pear Shaped Cabochon Lot

40+ Cts
20.5 to 8.5mm', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 179, 1, 'loose_stone', 'Aquamarine', NULL, NULL, NULL, NULL, NULL, NULL, '["https://media.gemworkers.com/items/02b97602-71f6-4b46-a537-fcee6835c105/etsy-1.jpg","https://media.gemworkers.com/items/02b97602-71f6-4b46-a537-fcee6835c105/etsy-2.jpg","https://media.gemworkers.com/items/02b97602-71f6-4b46-a537-fcee6835c105/etsy-3.jpg","https://media.gemworkers.com/items/02b97602-71f6-4b46-a537-fcee6835c105/etsy-4.jpg","https://media.gemworkers.com/items/02b97602-71f6-4b46-a537-fcee6835c105/etsy-5.jpg","https://media.gemworkers.com/items/02b97602-71f6-4b46-a537-fcee6835c105/etsy-6.jpg","https://media.gemworkers.com/items/02b97602-71f6-4b46-a537-fcee6835c105/etsy-7.jpg","https://media.gemworkers.com/items/02b97602-71f6-4b46-a537-fcee6835c105/etsy-8.jpg","https://media.gemworkers.com/items/02b97602-71f6-4b46-a537-fcee6835c105/etsy-9.jpg","https://media.gemworkers.com/items/02b97602-71f6-4b46-a537-fcee6835c105/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 200 USD, converted at ECB rate. Etsy tags: Santa Maria Cabochon,Blue Aquamarine,Unique Aquamarine,Rare Aquamarine,Aquamarine Cabochons,Bicolour Aquamarine,Bicolour Cabochons,Blue Cabochons,Lagoon Cabochons,Natural Stone,jewels,Oceangemsminerals,Rare Cabochons.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('51236f32-84e3-44cd-ba05-5040aefeccf3', '18.30 Cts Rubilite Tourmaline Lot', 'Gorgeous Rubilite Tourmaline Lot

18.30 CT’s 
7.1mm to 10mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 268, 1, 'loose_stone', 'Tourmaline', 'Rubellite', 18.3, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/51236f32-84e3-44cd-ba05-5040aefeccf3/etsy-1.jpg","https://media.gemworkers.com/items/51236f32-84e3-44cd-ba05-5040aefeccf3/etsy-2.jpg","https://media.gemworkers.com/items/51236f32-84e3-44cd-ba05-5040aefeccf3/etsy-3.jpg","https://media.gemworkers.com/items/51236f32-84e3-44cd-ba05-5040aefeccf3/etsy-4.jpg","https://media.gemworkers.com/items/51236f32-84e3-44cd-ba05-5040aefeccf3/etsy-5.jpg","https://media.gemworkers.com/items/51236f32-84e3-44cd-ba05-5040aefeccf3/etsy-6.jpg","https://media.gemworkers.com/items/51236f32-84e3-44cd-ba05-5040aefeccf3/etsy-7.jpg","https://media.gemworkers.com/items/51236f32-84e3-44cd-ba05-5040aefeccf3/etsy-8.jpg","https://media.gemworkers.com/items/51236f32-84e3-44cd-ba05-5040aefeccf3/etsy-9.jpg","https://media.gemworkers.com/items/51236f32-84e3-44cd-ba05-5040aefeccf3/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 300 USD, converted at ECB rate. Etsy tags: Red Rubilite,PigeonBlood Rubilite,Orange Rubilite,Pinkish Rubilite,Red Tourmaline,Pink Tourmaline,Orange Tourmaline,Cushion Cut,Tourmaline Jewellery,Tourmaline Faceted,Rubilite Tourmaline,Jewellery Making,Jewellery Findings.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('ec15a506-b6ee-4b4d-95ec-6536bcca4960', '13.70 Cts Rubilite Tourmaline Lot', 'Gorgeous Rubilite Tourmaline Lot

13.70 CT’s 
7.2mm to 8.4mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 223, 1, 'loose_stone', 'Tourmaline', 'Rubellite', 13.7, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/ec15a506-b6ee-4b4d-95ec-6536bcca4960/etsy-1.jpg","https://media.gemworkers.com/items/ec15a506-b6ee-4b4d-95ec-6536bcca4960/etsy-2.jpg","https://media.gemworkers.com/items/ec15a506-b6ee-4b4d-95ec-6536bcca4960/etsy-3.jpg","https://media.gemworkers.com/items/ec15a506-b6ee-4b4d-95ec-6536bcca4960/etsy-4.jpg","https://media.gemworkers.com/items/ec15a506-b6ee-4b4d-95ec-6536bcca4960/etsy-5.jpg","https://media.gemworkers.com/items/ec15a506-b6ee-4b4d-95ec-6536bcca4960/etsy-6.jpg","https://media.gemworkers.com/items/ec15a506-b6ee-4b4d-95ec-6536bcca4960/etsy-7.jpg","https://media.gemworkers.com/items/ec15a506-b6ee-4b4d-95ec-6536bcca4960/etsy-8.jpg","https://media.gemworkers.com/items/ec15a506-b6ee-4b4d-95ec-6536bcca4960/etsy-9.jpg","https://media.gemworkers.com/items/ec15a506-b6ee-4b4d-95ec-6536bcca4960/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 250 USD, converted at ECB rate. Etsy tags: Red Rubilite,PigeonBlood Rubilite,Orange Rubilite,Pinkish Rubilite,Red Tourmaline,Pink Tourmaline,Orange Tourmaline,Cushion Cut,Tourmaline Jewellery,Tourmaline Faceted,Rubilite Tourmaline,Jewellery Making,Jewellery Findings.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('4793d8e0-16b7-4066-9fcc-46d38563ffc6', '9.30 Cts Rubilite Tourmaline Lot', 'Gorgeous Rubilite Tourmaline Lot

9.30 CT’s 
5.5mm to 7.9mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 197, 1, 'loose_stone', 'Tourmaline', 'Rubellite', 9.3, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/4793d8e0-16b7-4066-9fcc-46d38563ffc6/etsy-1.jpg","https://media.gemworkers.com/items/4793d8e0-16b7-4066-9fcc-46d38563ffc6/etsy-2.jpg","https://media.gemworkers.com/items/4793d8e0-16b7-4066-9fcc-46d38563ffc6/etsy-3.jpg","https://media.gemworkers.com/items/4793d8e0-16b7-4066-9fcc-46d38563ffc6/etsy-4.jpg","https://media.gemworkers.com/items/4793d8e0-16b7-4066-9fcc-46d38563ffc6/etsy-5.jpg","https://media.gemworkers.com/items/4793d8e0-16b7-4066-9fcc-46d38563ffc6/etsy-6.jpg","https://media.gemworkers.com/items/4793d8e0-16b7-4066-9fcc-46d38563ffc6/etsy-7.jpg","https://media.gemworkers.com/items/4793d8e0-16b7-4066-9fcc-46d38563ffc6/etsy-8.jpg","https://media.gemworkers.com/items/4793d8e0-16b7-4066-9fcc-46d38563ffc6/etsy-9.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 220 USD, converted at ECB rate. Etsy tags: Red Rubilite,PigeonBlood Rubilite,Orange Rubilite,Pinkish Rubilite,Red Tourmaline,Pink Tourmaline,Orange Tourmaline,Cushion Cut,Tourmaline Jewellery,Tourmaline Faceted,Rubilite Tourmaline,Jewellery Making,Jewellery Findings.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('88c947b7-5ed3-4044-88a7-e97221018c4a', '12.80 Cts Rubilite Tourmaline Lot', 'Gorgeous Rubilite Tourmaline Lot

12.80 CT’s 
6.7mm to 8.8mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 161, 1, 'loose_stone', 'Tourmaline', 'Rubellite', 12.8, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/88c947b7-5ed3-4044-88a7-e97221018c4a/etsy-1.jpg","https://media.gemworkers.com/items/88c947b7-5ed3-4044-88a7-e97221018c4a/etsy-2.jpg","https://media.gemworkers.com/items/88c947b7-5ed3-4044-88a7-e97221018c4a/etsy-3.jpg","https://media.gemworkers.com/items/88c947b7-5ed3-4044-88a7-e97221018c4a/etsy-4.jpg","https://media.gemworkers.com/items/88c947b7-5ed3-4044-88a7-e97221018c4a/etsy-5.jpg","https://media.gemworkers.com/items/88c947b7-5ed3-4044-88a7-e97221018c4a/etsy-6.jpg","https://media.gemworkers.com/items/88c947b7-5ed3-4044-88a7-e97221018c4a/etsy-7.jpg","https://media.gemworkers.com/items/88c947b7-5ed3-4044-88a7-e97221018c4a/etsy-8.jpg","https://media.gemworkers.com/items/88c947b7-5ed3-4044-88a7-e97221018c4a/etsy-9.jpg","https://media.gemworkers.com/items/88c947b7-5ed3-4044-88a7-e97221018c4a/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 180 USD, converted at ECB rate. Etsy tags: Red Rubilite,PigeonBlood Rubilite,Orange Rubilite,Pinkish Rubilite,Red Tourmaline,Pink Tourmaline,Orange Tourmaline,Cushion Cut,Tourmaline Jewellery,Tourmaline Faceted,Rubilite Tourmaline,Jewellery Making,Jewellery Findings.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('4907f7f0-e69c-48ec-97f7-c3fcd245e453', '5.30 Cts Blue Tourmaline Lot', 'Blue and Teal Blue Colour Tourmaline Lot

One of a kind, top colours and and clarity.

5.30 Cts
5.9 x 5.9 x 4.2mm
5.4 x 5 x 4.2mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 223, 1, 'loose_stone', 'Tourmaline', NULL, 5.3, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/4907f7f0-e69c-48ec-97f7-c3fcd245e453/etsy-1.jpg","https://media.gemworkers.com/items/4907f7f0-e69c-48ec-97f7-c3fcd245e453/etsy-2.jpg","https://media.gemworkers.com/items/4907f7f0-e69c-48ec-97f7-c3fcd245e453/etsy-3.jpg","https://media.gemworkers.com/items/4907f7f0-e69c-48ec-97f7-c3fcd245e453/etsy-4.jpg","https://media.gemworkers.com/items/4907f7f0-e69c-48ec-97f7-c3fcd245e453/etsy-5.jpg","https://media.gemworkers.com/items/4907f7f0-e69c-48ec-97f7-c3fcd245e453/etsy-6.jpg","https://media.gemworkers.com/items/4907f7f0-e69c-48ec-97f7-c3fcd245e453/etsy-7.jpg","https://media.gemworkers.com/items/4907f7f0-e69c-48ec-97f7-c3fcd245e453/etsy-8.jpg","https://media.gemworkers.com/items/4907f7f0-e69c-48ec-97f7-c3fcd245e453/etsy-9.jpg","https://media.gemworkers.com/items/4907f7f0-e69c-48ec-97f7-c3fcd245e453/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 250 USD, converted at ECB rate. Etsy tags: Paraiba Tourmaline,Paraiba Colour,Lagoon Tourmaline,Bluegreen Tourmaline,Blue Tourmaline,Neon Blue Tourmaline,Tourmaline Jewellery,Jewellers,Lagoon Colour,Oceangemsminerals,Ink Blue Tourmaline,Wedding Rings,Rings For Women.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('0b8f5360-0761-43d1-8eed-a3d047811afd', '5.30 Cts Blue Tourmaline', 'Unique Blue Colour Tourmaline 

5.30 Cts
15 x 5.1 x 3.8mm
16 x 5.1 x 3.2mm

no treatment', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 223, 1, 'loose_stone', 'Tourmaline', NULL, 5.3, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/0b8f5360-0761-43d1-8eed-a3d047811afd/etsy-1.jpg","https://media.gemworkers.com/items/0b8f5360-0761-43d1-8eed-a3d047811afd/etsy-2.jpg","https://media.gemworkers.com/items/0b8f5360-0761-43d1-8eed-a3d047811afd/etsy-3.jpg","https://media.gemworkers.com/items/0b8f5360-0761-43d1-8eed-a3d047811afd/etsy-4.jpg","https://media.gemworkers.com/items/0b8f5360-0761-43d1-8eed-a3d047811afd/etsy-5.jpg","https://media.gemworkers.com/items/0b8f5360-0761-43d1-8eed-a3d047811afd/etsy-6.jpg","https://media.gemworkers.com/items/0b8f5360-0761-43d1-8eed-a3d047811afd/etsy-7.jpg","https://media.gemworkers.com/items/0b8f5360-0761-43d1-8eed-a3d047811afd/etsy-8.jpg","https://media.gemworkers.com/items/0b8f5360-0761-43d1-8eed-a3d047811afd/etsy-9.jpg","https://media.gemworkers.com/items/0b8f5360-0761-43d1-8eed-a3d047811afd/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 250 USD, converted at ECB rate. Etsy tags: jewellery supplies,earrings stud,hoop earrings,Blue tourmaline Pair,blue tourmaline,tourmaline pairs,natural stone,jewels,handmade,loose gemstones,lagoon tourmaline,Oceangemsminerals.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('00779297-6292-41dd-82e8-48d872003810', '2.45 Cts Olive Green & Blue Tourmalines: Unheated Gemstones', 'Gorgeous olive 🫒 green and blue tourmalines

2.45 Cts
6 x 7.2 x 5mm
5.3 x 5.3 x 3.2mm

Unheated untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 161, 1, 'loose_stone', 'Tourmaline', NULL, 2.45, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/00779297-6292-41dd-82e8-48d872003810/etsy-1.jpg","https://media.gemworkers.com/items/00779297-6292-41dd-82e8-48d872003810/etsy-2.jpg","https://media.gemworkers.com/items/00779297-6292-41dd-82e8-48d872003810/etsy-3.jpg","https://media.gemworkers.com/items/00779297-6292-41dd-82e8-48d872003810/etsy-4.jpg","https://media.gemworkers.com/items/00779297-6292-41dd-82e8-48d872003810/etsy-5.jpg","https://media.gemworkers.com/items/00779297-6292-41dd-82e8-48d872003810/etsy-6.jpg","https://media.gemworkers.com/items/00779297-6292-41dd-82e8-48d872003810/etsy-7.jpg","https://media.gemworkers.com/items/00779297-6292-41dd-82e8-48d872003810/etsy-8.jpg","https://media.gemworkers.com/items/00779297-6292-41dd-82e8-48d872003810/etsy-9.jpg","https://media.gemworkers.com/items/00779297-6292-41dd-82e8-48d872003810/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 180 USD, converted at ECB rate. Etsy tags: olive tourmaline,green tourmaline,lagoon tourmaline,blue tourmaline,Oceangemsminerals,rings for women,rings for men,jewellery making,jewellery findings,jewellery supplies,jewellers,tourmaline jewellery,tourmaline rings.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('d54cf107-9b24-4f94-bfad-56b61981877b', '3 Cts Vibrant Green Tourmalines', 'Beautiful green tourmaline 

Inclusion give it special characteristics 

3.00 Cts
9.5 x 7.5 x 5.5mm

Unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 125, 1, 'loose_stone', 'Tourmaline', NULL, 3, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/d54cf107-9b24-4f94-bfad-56b61981877b/etsy-1.jpg","https://media.gemworkers.com/items/d54cf107-9b24-4f94-bfad-56b61981877b/etsy-2.jpg","https://media.gemworkers.com/items/d54cf107-9b24-4f94-bfad-56b61981877b/etsy-3.jpg","https://media.gemworkers.com/items/d54cf107-9b24-4f94-bfad-56b61981877b/etsy-4.jpg","https://media.gemworkers.com/items/d54cf107-9b24-4f94-bfad-56b61981877b/etsy-5.jpg","https://media.gemworkers.com/items/d54cf107-9b24-4f94-bfad-56b61981877b/etsy-6.jpg","https://media.gemworkers.com/items/d54cf107-9b24-4f94-bfad-56b61981877b/etsy-7.jpg","https://media.gemworkers.com/items/d54cf107-9b24-4f94-bfad-56b61981877b/etsy-8.jpg","https://media.gemworkers.com/items/d54cf107-9b24-4f94-bfad-56b61981877b/etsy-9.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 140 USD, converted at ECB rate. Etsy tags: Green Tourmaline,Vibrant Tourmaline,AppleGreenTourmaline,Tourmaline jewellery,jewellers,jewellery making,jewellery supplies,jewellery findings,Oceangemsminerals,rings for women,rings for men,rings jewellery,natural stone.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('953ccc89-2c52-42d7-97fa-046425d966ce', '7.70 Cts Tourmaline Lot.', 'Mesmerising cut mix colour tourmaline Lot

7.70 Cts
9 x 6.5 x 5mm
7 x 6.5 x 4.5mm
6.4 x 6.2 x 5.4mm

Unheated, Untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 232, 1, 'loose_stone', 'Tourmaline', NULL, 7.7, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/953ccc89-2c52-42d7-97fa-046425d966ce/etsy-1.jpg","https://media.gemworkers.com/items/953ccc89-2c52-42d7-97fa-046425d966ce/etsy-2.jpg","https://media.gemworkers.com/items/953ccc89-2c52-42d7-97fa-046425d966ce/etsy-3.jpg","https://media.gemworkers.com/items/953ccc89-2c52-42d7-97fa-046425d966ce/etsy-4.jpg","https://media.gemworkers.com/items/953ccc89-2c52-42d7-97fa-046425d966ce/etsy-5.jpg","https://media.gemworkers.com/items/953ccc89-2c52-42d7-97fa-046425d966ce/etsy-6.jpg","https://media.gemworkers.com/items/953ccc89-2c52-42d7-97fa-046425d966ce/etsy-7.jpg","https://media.gemworkers.com/items/953ccc89-2c52-42d7-97fa-046425d966ce/etsy-8.jpg","https://media.gemworkers.com/items/953ccc89-2c52-42d7-97fa-046425d966ce/etsy-9.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 260 USD, converted at ECB rate. Etsy tags: Jewellery Making,Jewellery Findings,Tourmaline Jewellery,Tourmaline Supplies,Tourmaline Lot,Mix Color Tourmaline,Natural Stone,Pink Tourmaline,Gift For Her,Necklace Findings,blue tourmaline,lagoon tourmaline,Oceangemsminerals.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('039f2c7e-c2f4-4388-9474-e4530200a259', '5.15 Cts Tourmaline lot', 'mix colour tourmaline lot 

good lustre and brilliance 

5.15 Cts
8.4 to 4.6mm long

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 125, 1, 'loose_stone', 'Tourmaline', NULL, 5.15, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/039f2c7e-c2f4-4388-9474-e4530200a259/etsy-1.jpg","https://media.gemworkers.com/items/039f2c7e-c2f4-4388-9474-e4530200a259/etsy-2.jpg","https://media.gemworkers.com/items/039f2c7e-c2f4-4388-9474-e4530200a259/etsy-3.jpg","https://media.gemworkers.com/items/039f2c7e-c2f4-4388-9474-e4530200a259/etsy-4.jpg","https://media.gemworkers.com/items/039f2c7e-c2f4-4388-9474-e4530200a259/etsy-5.jpg","https://media.gemworkers.com/items/039f2c7e-c2f4-4388-9474-e4530200a259/etsy-6.jpg","https://media.gemworkers.com/items/039f2c7e-c2f4-4388-9474-e4530200a259/etsy-7.jpg","https://media.gemworkers.com/items/039f2c7e-c2f4-4388-9474-e4530200a259/etsy-8.jpg","https://media.gemworkers.com/items/039f2c7e-c2f4-4388-9474-e4530200a259/etsy-9.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 140 USD, converted at ECB rate. Etsy tags: Paraiba Tourmaline,Paraiba Colour,Lagoon Tourmaline,Bluegreen Tourmaline,Blue Tourmaline,Neon Blue Tourmaline,Tourmaline Jewellery,Jewellers,Lagoon Colour,Oceangemsminerals,Ink Blue Tourmaline,Wedding Rings,Rings For Women.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('5886dbc5-f117-4855-ba76-c32fa25ee2c9', '4.70 Cts, Bicolour Tourmaline set', 'Natural Afghanistan Bicolour Tourmaline Set

Very Unique And One Of A Kind

4.70 Cts
15.5 x 3.2 x 2.8mm

calibrated size.

unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 268, 1, 'loose_stone', 'Tourmaline', NULL, 4.7, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/5886dbc5-f117-4855-ba76-c32fa25ee2c9/etsy-1.jpg","https://media.gemworkers.com/items/5886dbc5-f117-4855-ba76-c32fa25ee2c9/etsy-2.jpg","https://media.gemworkers.com/items/5886dbc5-f117-4855-ba76-c32fa25ee2c9/etsy-3.jpg","https://media.gemworkers.com/items/5886dbc5-f117-4855-ba76-c32fa25ee2c9/etsy-4.jpg","https://media.gemworkers.com/items/5886dbc5-f117-4855-ba76-c32fa25ee2c9/etsy-5.jpg","https://media.gemworkers.com/items/5886dbc5-f117-4855-ba76-c32fa25ee2c9/etsy-6.jpg","https://media.gemworkers.com/items/5886dbc5-f117-4855-ba76-c32fa25ee2c9/etsy-7.jpg","https://media.gemworkers.com/items/5886dbc5-f117-4855-ba76-c32fa25ee2c9/etsy-8.jpg","https://media.gemworkers.com/items/5886dbc5-f117-4855-ba76-c32fa25ee2c9/etsy-9.jpg","https://media.gemworkers.com/items/5886dbc5-f117-4855-ba76-c32fa25ee2c9/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 300 USD, converted at ECB rate. Etsy tags: Gold Rings,Rings For Men,Gift For Her,Tourmaline Jewellery,Natural Stone,Stud Earrings,Jewellery Stud,bicolour Tourmaline,Lagoon tourmaline,Tricolour Tourmaline,Oceangemsminerals,blue tourmaline,tourmaline pairs.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('2cead805-6eb3-48c6-9f1d-d9b96df6e0d0', '4.55 Cts Seafoam Tourmaline.', 'Gorgeous Blue Green And Seafoam Tourmaline 

included but very high lustre.

4.55 Cts
9 x 5.4 x 4.3mm
6.9 x 6 x 4.8mm
4.5 x 6.8 x 5.2mm

Unheated untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 214, 1, 'loose_stone', 'Tourmaline', NULL, 4.55, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/2cead805-6eb3-48c6-9f1d-d9b96df6e0d0/etsy-1.jpg","https://media.gemworkers.com/items/2cead805-6eb3-48c6-9f1d-d9b96df6e0d0/etsy-2.jpg","https://media.gemworkers.com/items/2cead805-6eb3-48c6-9f1d-d9b96df6e0d0/etsy-3.jpg","https://media.gemworkers.com/items/2cead805-6eb3-48c6-9f1d-d9b96df6e0d0/etsy-4.jpg","https://media.gemworkers.com/items/2cead805-6eb3-48c6-9f1d-d9b96df6e0d0/etsy-5.jpg","https://media.gemworkers.com/items/2cead805-6eb3-48c6-9f1d-d9b96df6e0d0/etsy-6.jpg","https://media.gemworkers.com/items/2cead805-6eb3-48c6-9f1d-d9b96df6e0d0/etsy-7.jpg","https://media.gemworkers.com/items/2cead805-6eb3-48c6-9f1d-d9b96df6e0d0/etsy-8.jpg","https://media.gemworkers.com/items/2cead805-6eb3-48c6-9f1d-d9b96df6e0d0/etsy-9.jpg","https://media.gemworkers.com/items/2cead805-6eb3-48c6-9f1d-d9b96df6e0d0/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 240 USD, converted at ECB rate. Etsy tags: seafoam tourmaline,mint Green tourmalin,lagoon tourmaline,blue tourmaline,green tourmaline,Oceangemsminerals,jewellery findings,rings for women,rings for men,tourmaline jewellery,jewellers,Handmadejewellery,natural stone.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('d937b0dd-4e9a-4270-85d5-1c2bf9098be2', '11.50 Cts Vibrant Tourmaline Gemstone Lot: Unheated, Untreated', 'Top Quality Tourmaline Lot

Best and vibrant colours 

11.50 Cts
6 x 5 x 5mm to 12 x 5 x 4mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 313, 1, 'loose_stone', 'Tourmaline', NULL, 11.5, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/d937b0dd-4e9a-4270-85d5-1c2bf9098be2/etsy-1.jpg","https://media.gemworkers.com/items/d937b0dd-4e9a-4270-85d5-1c2bf9098be2/etsy-2.jpg","https://media.gemworkers.com/items/d937b0dd-4e9a-4270-85d5-1c2bf9098be2/etsy-3.jpg","https://media.gemworkers.com/items/d937b0dd-4e9a-4270-85d5-1c2bf9098be2/etsy-4.jpg","https://media.gemworkers.com/items/d937b0dd-4e9a-4270-85d5-1c2bf9098be2/etsy-5.jpg","https://media.gemworkers.com/items/d937b0dd-4e9a-4270-85d5-1c2bf9098be2/etsy-6.jpg","https://media.gemworkers.com/items/d937b0dd-4e9a-4270-85d5-1c2bf9098be2/etsy-7.jpg","https://media.gemworkers.com/items/d937b0dd-4e9a-4270-85d5-1c2bf9098be2/etsy-8.jpg","https://media.gemworkers.com/items/d937b0dd-4e9a-4270-85d5-1c2bf9098be2/etsy-9.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 350 USD, converted at ECB rate. Etsy tags: Tourmaline Lot,Tourmaline Jewellery,Bluegreen Tourmaline,Lagoon Tourmaline,Blue Tourmaline,Green Tourmaline,Seafoam Tourmaline,Bicolour Tourmaline,Oceangemsminerals,Mint Tourmaline,Vivid Tourmaline Lot,Tourmaline Supplies,Jewellers.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('63b2782d-a921-4416-840a-ab22e6db2c71', '4 Cts Ink Blue Tourmaline', 'Gorgeous Mesmerising Rare Ink Blue Colour Afghan Tourmaline 

Open Colour, Exceptional piece

4.00 Cts
10.5 x 7.5 x 6mm

unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 357, 1, 'loose_stone', 'Tourmaline', NULL, 4, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/63b2782d-a921-4416-840a-ab22e6db2c71/etsy-1.jpg","https://media.gemworkers.com/items/63b2782d-a921-4416-840a-ab22e6db2c71/etsy-2.jpg","https://media.gemworkers.com/items/63b2782d-a921-4416-840a-ab22e6db2c71/etsy-3.jpg","https://media.gemworkers.com/items/63b2782d-a921-4416-840a-ab22e6db2c71/etsy-4.jpg","https://media.gemworkers.com/items/63b2782d-a921-4416-840a-ab22e6db2c71/etsy-5.jpg","https://media.gemworkers.com/items/63b2782d-a921-4416-840a-ab22e6db2c71/etsy-6.jpg","https://media.gemworkers.com/items/63b2782d-a921-4416-840a-ab22e6db2c71/etsy-7.jpg","https://media.gemworkers.com/items/63b2782d-a921-4416-840a-ab22e6db2c71/etsy-8.jpg","https://media.gemworkers.com/items/63b2782d-a921-4416-840a-ab22e6db2c71/etsy-9.jpg","https://media.gemworkers.com/items/63b2782d-a921-4416-840a-ab22e6db2c71/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 400 USD, converted at ECB rate. Etsy tags: Gold Rings,Rings For Men,Rings For Women,Tourmaline Jewellery,Natural Stone,bicolour Tourmaline,Lagoon tourmaline,Bluegreen tourmaline,blue tourmaline,indigo tourmaline,Oceangemsminerals,rare tourmaline,ink blue tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('73af1939-4581-419a-a2e4-b8a0b6a8e9a8', '8.8 Cts Unique Tricolour Tourmaline', 'Gorgeous Mesmerising Tricolour Natural Afghanistan Tourmaline 

More beautiful In real, One of a kind

Green, Blue, Pink Combination 

8.80 Cts
14.8 x 8.5 x 7mm

unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 143, 1, 'loose_stone', 'Tourmaline', NULL, 8.8, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/73af1939-4581-419a-a2e4-b8a0b6a8e9a8/etsy-1.jpg","https://media.gemworkers.com/items/73af1939-4581-419a-a2e4-b8a0b6a8e9a8/etsy-2.jpg","https://media.gemworkers.com/items/73af1939-4581-419a-a2e4-b8a0b6a8e9a8/etsy-3.jpg","https://media.gemworkers.com/items/73af1939-4581-419a-a2e4-b8a0b6a8e9a8/etsy-4.jpg","https://media.gemworkers.com/items/73af1939-4581-419a-a2e4-b8a0b6a8e9a8/etsy-5.jpg","https://media.gemworkers.com/items/73af1939-4581-419a-a2e4-b8a0b6a8e9a8/etsy-6.jpg","https://media.gemworkers.com/items/73af1939-4581-419a-a2e4-b8a0b6a8e9a8/etsy-7.jpg","https://media.gemworkers.com/items/73af1939-4581-419a-a2e4-b8a0b6a8e9a8/etsy-8.jpg","https://media.gemworkers.com/items/73af1939-4581-419a-a2e4-b8a0b6a8e9a8/etsy-9.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 160 USD, converted at ECB rate. Etsy tags: Gold Rings,Rings For Men,Gift For Her,Tourmaline Jewellery,Natural Stone,Stud Earrings,Jewellery Stud,bicolour Tourmaline,Lagoon tourmaline,Tricolour Tourmaline,Oceangemsminerals,blue tourmaline,tourmaline pairs.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('91de27ca-f327-4417-987e-29313b673e6b', '24.6 Cts Bicolour Tourmaline Rosecuts lot', 'Gorgeous Bicolour Tourmaline Rosecuts Lot

 Nice Polished

24.60 Cts
5 to 10.5mm

unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 125, 1, 'loose_stone', 'Tourmaline', NULL, 24.6, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/91de27ca-f327-4417-987e-29313b673e6b/etsy-1.jpg","https://media.gemworkers.com/items/91de27ca-f327-4417-987e-29313b673e6b/etsy-2.jpg","https://media.gemworkers.com/items/91de27ca-f327-4417-987e-29313b673e6b/etsy-3.jpg","https://media.gemworkers.com/items/91de27ca-f327-4417-987e-29313b673e6b/etsy-4.jpg","https://media.gemworkers.com/items/91de27ca-f327-4417-987e-29313b673e6b/etsy-5.jpg","https://media.gemworkers.com/items/91de27ca-f327-4417-987e-29313b673e6b/etsy-6.jpg","https://media.gemworkers.com/items/91de27ca-f327-4417-987e-29313b673e6b/etsy-7.jpg","https://media.gemworkers.com/items/91de27ca-f327-4417-987e-29313b673e6b/etsy-8.jpg","https://media.gemworkers.com/items/91de27ca-f327-4417-987e-29313b673e6b/etsy-9.jpg","https://media.gemworkers.com/items/91de27ca-f327-4417-987e-29313b673e6b/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 140 USD, converted at ECB rate. Etsy tags: Santa Maria Cabochon,Unique Aquamarine,Bicolour Aquamarine,Bicolour Cabochons,Blue Cabochons,Lagoon Cabochons,Natural Stone,jewels,Oceangemsminerals,Tourmaline Rosecuts,Lagoon Rosecuts,Blue Tourmaline,Blue Rosecuts.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('82803d4f-e024-4b3b-85f7-c41921c201bf', '7.8 Cts Unique Tricolour Tourmaline', 'Gorgeous Mesmerising Tricolour Natural Afghanistan Tourmaline 

More beautiful In real, One of a kind

7.85 Cts
10.7 x 10.2 x 7.5mm

unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 313, 1, 'loose_stone', 'Tourmaline', NULL, 7.8, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/82803d4f-e024-4b3b-85f7-c41921c201bf/etsy-1.jpg","https://media.gemworkers.com/items/82803d4f-e024-4b3b-85f7-c41921c201bf/etsy-2.jpg","https://media.gemworkers.com/items/82803d4f-e024-4b3b-85f7-c41921c201bf/etsy-3.jpg","https://media.gemworkers.com/items/82803d4f-e024-4b3b-85f7-c41921c201bf/etsy-4.jpg","https://media.gemworkers.com/items/82803d4f-e024-4b3b-85f7-c41921c201bf/etsy-5.jpg","https://media.gemworkers.com/items/82803d4f-e024-4b3b-85f7-c41921c201bf/etsy-6.jpg","https://media.gemworkers.com/items/82803d4f-e024-4b3b-85f7-c41921c201bf/etsy-7.jpg","https://media.gemworkers.com/items/82803d4f-e024-4b3b-85f7-c41921c201bf/etsy-8.jpg","https://media.gemworkers.com/items/82803d4f-e024-4b3b-85f7-c41921c201bf/etsy-9.jpg","https://media.gemworkers.com/items/82803d4f-e024-4b3b-85f7-c41921c201bf/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 350 USD, converted at ECB rate. Etsy tags: Gold Rings,Rings For Men,Gift For Her,Tourmaline Jewellery,Natural Stone,Stud Earrings,Jewellery Stud,bicolour Tourmaline,Lagoon tourmaline,Tricolour Tourmaline,Oceangemsminerals,blue tourmaline,tourmaline pairs.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('1b573e0f-ac12-4144-adc2-de1d0ab6ca02', '7.7 Cts Unique Tricolour Tourmaline', 'Gorgeous Mesmerising Tricolour Natural Afghanistan Tourmaline 

More beautiful In real, One of a kind

7.7 Cts
10.8 x 10 x 7.4mm

unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 313, 1, 'loose_stone', 'Tourmaline', NULL, 7.7, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/1b573e0f-ac12-4144-adc2-de1d0ab6ca02/etsy-1.jpg","https://media.gemworkers.com/items/1b573e0f-ac12-4144-adc2-de1d0ab6ca02/etsy-2.jpg","https://media.gemworkers.com/items/1b573e0f-ac12-4144-adc2-de1d0ab6ca02/etsy-3.jpg","https://media.gemworkers.com/items/1b573e0f-ac12-4144-adc2-de1d0ab6ca02/etsy-4.jpg","https://media.gemworkers.com/items/1b573e0f-ac12-4144-adc2-de1d0ab6ca02/etsy-5.jpg","https://media.gemworkers.com/items/1b573e0f-ac12-4144-adc2-de1d0ab6ca02/etsy-6.jpg","https://media.gemworkers.com/items/1b573e0f-ac12-4144-adc2-de1d0ab6ca02/etsy-7.jpg","https://media.gemworkers.com/items/1b573e0f-ac12-4144-adc2-de1d0ab6ca02/etsy-8.jpg","https://media.gemworkers.com/items/1b573e0f-ac12-4144-adc2-de1d0ab6ca02/etsy-9.jpg","https://media.gemworkers.com/items/1b573e0f-ac12-4144-adc2-de1d0ab6ca02/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 350 USD, converted at ECB rate. Etsy tags: Gold Rings,Rings For Men,Gift For Her,Tourmaline Jewellery,Natural Stone,Stud Earrings,Jewellery Stud,bicolour Tourmaline,Lagoon tourmaline,Tricolour Tourmaline,Oceangemsminerals,blue tourmaline,tourmaline pairs.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('ee21f4da-068b-4109-b89f-37464fd12ed1', '1.10 Cts Apple Tourmaline.', 'Gorgeous apple green and pink from bottom Unique Tourmaline

lovely and unique pieces,

1.10 Cts
6.6 x 5.3 x 4.1mm

Unheated, Untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 80, 1, 'loose_stone', 'Tourmaline', NULL, 1.1, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/ee21f4da-068b-4109-b89f-37464fd12ed1/etsy-1.jpg","https://media.gemworkers.com/items/ee21f4da-068b-4109-b89f-37464fd12ed1/etsy-2.jpg","https://media.gemworkers.com/items/ee21f4da-068b-4109-b89f-37464fd12ed1/etsy-3.jpg","https://media.gemworkers.com/items/ee21f4da-068b-4109-b89f-37464fd12ed1/etsy-4.jpg","https://media.gemworkers.com/items/ee21f4da-068b-4109-b89f-37464fd12ed1/etsy-5.jpg","https://media.gemworkers.com/items/ee21f4da-068b-4109-b89f-37464fd12ed1/etsy-6.jpg","https://media.gemworkers.com/items/ee21f4da-068b-4109-b89f-37464fd12ed1/etsy-7.jpg","https://media.gemworkers.com/items/ee21f4da-068b-4109-b89f-37464fd12ed1/etsy-8.jpg","https://media.gemworkers.com/items/ee21f4da-068b-4109-b89f-37464fd12ed1/etsy-9.jpg","https://media.gemworkers.com/items/ee21f4da-068b-4109-b89f-37464fd12ed1/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 90 USD, converted at ECB rate. Etsy tags: Rings For Men,y2k earrings stud,Natural Stone,Tourmaline Supplies,Stud Earrings,pink tourmaline,Oceangemsminerals,Round Cut,Hot Pink Tourmaline,Lagoon Tourmaline,Blue Tourmaline,Bluegreen Tourmaline,Tourmaline Pair.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('44159890-859e-4395-9381-f46b415aba71', '2 Cts Rubilite Tourmaline', 'Gorgeous Pegeon Blood 🩸Colour Rubilite Tourmaline best for ring 💍 

2 cts
7.7 x 6.9 x 4.1 mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 356, 1, 'loose_stone', 'Tourmaline', 'Rubellite', 2, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/44159890-859e-4395-9381-f46b415aba71/etsy-1.jpg","https://media.gemworkers.com/items/44159890-859e-4395-9381-f46b415aba71/etsy-2.jpg","https://media.gemworkers.com/items/44159890-859e-4395-9381-f46b415aba71/etsy-3.jpg","https://media.gemworkers.com/items/44159890-859e-4395-9381-f46b415aba71/etsy-4.jpg","https://media.gemworkers.com/items/44159890-859e-4395-9381-f46b415aba71/etsy-5.jpg","https://media.gemworkers.com/items/44159890-859e-4395-9381-f46b415aba71/etsy-6.jpg","https://media.gemworkers.com/items/44159890-859e-4395-9381-f46b415aba71/etsy-7.jpg","https://media.gemworkers.com/items/44159890-859e-4395-9381-f46b415aba71/etsy-8.jpg","https://media.gemworkers.com/items/44159890-859e-4395-9381-f46b415aba71/etsy-9.jpg","https://media.gemworkers.com/items/44159890-859e-4395-9381-f46b415aba71/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 399 USD, converted at ECB rate. Etsy tags: Red Rubilite,PigeonBlood Rubilite,Orange Rubilite,Pinkish Rubilite,Red Tourmaline,Pink Tourmaline,Orange Tourmaline,Cushion Cut,Tourmaline Jewellery,Tourmaline Faceted,Rubilite Tourmaline,Jewellery Making,Jewellery Findings.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('a8d64464-7b0d-4c63-a66d-db4b4e92bc6e', '3 Cts Indicolite Tourmaline', 'Top Indicolite Colour Tourmaline Emerald Cut 

rare find

3 Cts 
9.8x6.2x4.7mm

No Treatment Whatsoever.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 356, 1, 'loose_stone', 'Tourmaline', 'Indicolite', 3, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/a8d64464-7b0d-4c63-a66d-db4b4e92bc6e/etsy-1.jpg","https://media.gemworkers.com/items/a8d64464-7b0d-4c63-a66d-db4b4e92bc6e/etsy-2.jpg","https://media.gemworkers.com/items/a8d64464-7b0d-4c63-a66d-db4b4e92bc6e/etsy-3.jpg","https://media.gemworkers.com/items/a8d64464-7b0d-4c63-a66d-db4b4e92bc6e/etsy-4.jpg","https://media.gemworkers.com/items/a8d64464-7b0d-4c63-a66d-db4b4e92bc6e/etsy-5.jpg","https://media.gemworkers.com/items/a8d64464-7b0d-4c63-a66d-db4b4e92bc6e/etsy-6.jpg","https://media.gemworkers.com/items/a8d64464-7b0d-4c63-a66d-db4b4e92bc6e/etsy-7.jpg","https://media.gemworkers.com/items/a8d64464-7b0d-4c63-a66d-db4b4e92bc6e/etsy-8.jpg","https://media.gemworkers.com/items/a8d64464-7b0d-4c63-a66d-db4b4e92bc6e/etsy-9.jpg","https://media.gemworkers.com/items/a8d64464-7b0d-4c63-a66d-db4b4e92bc6e/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 399 USD, converted at ECB rate. Etsy tags: Emerald Cut,EmeraldCutTourmaline,Jewellery making,earrings stud,Tourmaline Lot,Blue Tourmaline,Lagoon Tourmaline,Neon Blue,neon blue tourmaline,Rings For Men,Tourmalines,Ink Blue Tourmaline,Oceangemsminerals.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('5f0637f8-2c4e-4279-89b8-8f2db5a2bab8', '2 Cts Baby Pink Tourmaline Pair', 'mesmerising baby pink tourmaline 

Top Quality Fineest Colour

2 Cts 
6.8x4.7x3.7mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 356, 1, 'loose_stone', 'Tourmaline', NULL, 2, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/5f0637f8-2c4e-4279-89b8-8f2db5a2bab8/etsy-1.jpg","https://media.gemworkers.com/items/5f0637f8-2c4e-4279-89b8-8f2db5a2bab8/etsy-2.jpg","https://media.gemworkers.com/items/5f0637f8-2c4e-4279-89b8-8f2db5a2bab8/etsy-3.jpg","https://media.gemworkers.com/items/5f0637f8-2c4e-4279-89b8-8f2db5a2bab8/etsy-4.jpg","https://media.gemworkers.com/items/5f0637f8-2c4e-4279-89b8-8f2db5a2bab8/etsy-5.jpg","https://media.gemworkers.com/items/5f0637f8-2c4e-4279-89b8-8f2db5a2bab8/etsy-6.jpg","https://media.gemworkers.com/items/5f0637f8-2c4e-4279-89b8-8f2db5a2bab8/etsy-7.jpg","https://media.gemworkers.com/items/5f0637f8-2c4e-4279-89b8-8f2db5a2bab8/etsy-8.jpg","https://media.gemworkers.com/items/5f0637f8-2c4e-4279-89b8-8f2db5a2bab8/etsy-9.jpg","https://media.gemworkers.com/items/5f0637f8-2c4e-4279-89b8-8f2db5a2bab8/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 399 USD, converted at ECB rate. Etsy tags: Emerald Cut,Bicolour Tourmaline,Tricolour Tourmaline,Pink Bicolour,Unheated,Tourmaline jewellery,Natural Stone,Gift For Her,Blue tourmalines,Green Tourmaline,Rings For Men,Gold Rings,Stud Jewellery.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('15ff1330-f472-48fc-946b-71859c6ed8a1', '1.25 Cts Ink Blue Tourmaline', 'Top Ink Blue Colour Tourmaline Emerald Cut 

rare find

1.25 Cts 
6.1x5.4x4.5mm

No Treatment Whatsoever.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 267, 1, 'loose_stone', 'Tourmaline', NULL, 1.25, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/15ff1330-f472-48fc-946b-71859c6ed8a1/etsy-1.jpg","https://media.gemworkers.com/items/15ff1330-f472-48fc-946b-71859c6ed8a1/etsy-2.jpg","https://media.gemworkers.com/items/15ff1330-f472-48fc-946b-71859c6ed8a1/etsy-3.jpg","https://media.gemworkers.com/items/15ff1330-f472-48fc-946b-71859c6ed8a1/etsy-4.jpg","https://media.gemworkers.com/items/15ff1330-f472-48fc-946b-71859c6ed8a1/etsy-5.jpg","https://media.gemworkers.com/items/15ff1330-f472-48fc-946b-71859c6ed8a1/etsy-6.jpg","https://media.gemworkers.com/items/15ff1330-f472-48fc-946b-71859c6ed8a1/etsy-7.jpg","https://media.gemworkers.com/items/15ff1330-f472-48fc-946b-71859c6ed8a1/etsy-8.jpg","https://media.gemworkers.com/items/15ff1330-f472-48fc-946b-71859c6ed8a1/etsy-9.jpg","https://media.gemworkers.com/items/15ff1330-f472-48fc-946b-71859c6ed8a1/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 299 USD, converted at ECB rate. Etsy tags: Emerald Cut,EmeraldCutTourmaline,Jewellery making,earrings stud,Tourmaline Lot,Blue Tourmaline,Lagoon Tourmaline,Neon Blue,neon blue tourmaline,Rings For Men,Tourmalines,Ink Blue Tourmaline,Oceangemsminerals.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('84728673-b40c-4b98-b8f8-e4eedf49f950', '1 Cts Baby Pink Tourmaline', 'mesmerising baby pink tourmaline 

Top Quality Fineest Colour

1 cts 
Size:7.1x4.7x3.3mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 179, 1, 'loose_stone', 'Tourmaline', NULL, 1, 'ct', NULL, NULL, '7.1x4.7x3.3', '["https://media.gemworkers.com/items/84728673-b40c-4b98-b8f8-e4eedf49f950/etsy-1.jpg","https://media.gemworkers.com/items/84728673-b40c-4b98-b8f8-e4eedf49f950/etsy-2.jpg","https://media.gemworkers.com/items/84728673-b40c-4b98-b8f8-e4eedf49f950/etsy-3.jpg","https://media.gemworkers.com/items/84728673-b40c-4b98-b8f8-e4eedf49f950/etsy-4.jpg","https://media.gemworkers.com/items/84728673-b40c-4b98-b8f8-e4eedf49f950/etsy-5.jpg","https://media.gemworkers.com/items/84728673-b40c-4b98-b8f8-e4eedf49f950/etsy-6.jpg","https://media.gemworkers.com/items/84728673-b40c-4b98-b8f8-e4eedf49f950/etsy-7.jpg","https://media.gemworkers.com/items/84728673-b40c-4b98-b8f8-e4eedf49f950/etsy-8.jpg","https://media.gemworkers.com/items/84728673-b40c-4b98-b8f8-e4eedf49f950/etsy-9.jpg","https://media.gemworkers.com/items/84728673-b40c-4b98-b8f8-e4eedf49f950/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 200 USD, converted at ECB rate. Etsy tags: Emerald Cut,Bicolour Tourmaline,Tricolour Tourmaline,Pink Bicolour,Unheated,Tourmaline jewellery,Natural Stone,Gift For Her,Blue tourmalines,Green Tourmaline,Rings For Men,Gold Rings,Stud Jewellery.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('b414df88-ae85-4230-9917-656999e1db13', '1.9 Cts teal blue Tourmaline', 'Teal blue colour tourmaline

mesmerising rare colour, cute looking tourmaline.

1.90 Cts 
6.9x6.2x4.7mm

no treatment whatsoever.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 267, 1, 'loose_stone', 'Tourmaline', NULL, 1.9, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/b414df88-ae85-4230-9917-656999e1db13/etsy-1.jpg","https://media.gemworkers.com/items/b414df88-ae85-4230-9917-656999e1db13/etsy-2.jpg","https://media.gemworkers.com/items/b414df88-ae85-4230-9917-656999e1db13/etsy-3.jpg","https://media.gemworkers.com/items/b414df88-ae85-4230-9917-656999e1db13/etsy-4.jpg","https://media.gemworkers.com/items/b414df88-ae85-4230-9917-656999e1db13/etsy-5.jpg","https://media.gemworkers.com/items/b414df88-ae85-4230-9917-656999e1db13/etsy-6.jpg","https://media.gemworkers.com/items/b414df88-ae85-4230-9917-656999e1db13/etsy-7.jpg","https://media.gemworkers.com/items/b414df88-ae85-4230-9917-656999e1db13/etsy-8.jpg","https://media.gemworkers.com/items/b414df88-ae85-4230-9917-656999e1db13/etsy-9.jpg","https://media.gemworkers.com/items/b414df88-ae85-4230-9917-656999e1db13/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 299 USD, converted at ECB rate. Etsy tags: Tourmaline Jewellery,Tourmaline Rings,Blue Tourmaline,Gift For Her,Rings For Women,Rings For Men,Gold Rings,Natural Stone,lagoon tourmaline,indigo tourmaline,indicolitetourmaline,Oceangemsminerals,ink blue tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('61f5ccfb-7ed6-42db-8cbd-0d321fc924d2', '14.3 Cts Watermelon Bicolour Tourmalines', 'Sweet Perfect Watermelon Tourmaline 

Unique And Rare Colour

Very Shiny And High Lustre 

14.30 Cts 

Size:11.5mm to 21.5mm

No treatment.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 446, 1, 'loose_stone', 'Tourmaline', 'Watermelon', 14.3, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/61f5ccfb-7ed6-42db-8cbd-0d321fc924d2/etsy-1.jpg","https://media.gemworkers.com/items/61f5ccfb-7ed6-42db-8cbd-0d321fc924d2/etsy-2.jpg","https://media.gemworkers.com/items/61f5ccfb-7ed6-42db-8cbd-0d321fc924d2/etsy-3.jpg","https://media.gemworkers.com/items/61f5ccfb-7ed6-42db-8cbd-0d321fc924d2/etsy-4.jpg","https://media.gemworkers.com/items/61f5ccfb-7ed6-42db-8cbd-0d321fc924d2/etsy-5.jpg","https://media.gemworkers.com/items/61f5ccfb-7ed6-42db-8cbd-0d321fc924d2/etsy-6.jpg","https://media.gemworkers.com/items/61f5ccfb-7ed6-42db-8cbd-0d321fc924d2/etsy-7.jpg","https://media.gemworkers.com/items/61f5ccfb-7ed6-42db-8cbd-0d321fc924d2/etsy-8.jpg","https://media.gemworkers.com/items/61f5ccfb-7ed6-42db-8cbd-0d321fc924d2/etsy-9.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 499 USD, converted at ECB rate. Etsy tags: Tourmaline Jewellery,Tourmaline Earrings,Earrings Stud,y2k earrings stud,Gold Rings,Natural Stone,Gift For Her,Rings For Men,Oceangemsminerals,lagoon tourmaline,tourmaline pairs,bicolour tourmaline,Watermelon Bicolour.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('2635dc69-c7c9-4e4c-89d8-3066f1aa2765', '11.1 Cts Watermelon Bicolour Tourmalines', 'Sweet Perfect Watermelon Tourmaline 

Unique And Rare Colour

Very Shiny And High Lustre 

11.10 Cts 

Size:6mm to 19.4mm

No treatment.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 223, 1, 'loose_stone', 'Tourmaline', 'Watermelon', 11.1, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/2635dc69-c7c9-4e4c-89d8-3066f1aa2765/etsy-1.jpg","https://media.gemworkers.com/items/2635dc69-c7c9-4e4c-89d8-3066f1aa2765/etsy-2.jpg","https://media.gemworkers.com/items/2635dc69-c7c9-4e4c-89d8-3066f1aa2765/etsy-3.jpg","https://media.gemworkers.com/items/2635dc69-c7c9-4e4c-89d8-3066f1aa2765/etsy-4.jpg","https://media.gemworkers.com/items/2635dc69-c7c9-4e4c-89d8-3066f1aa2765/etsy-5.jpg","https://media.gemworkers.com/items/2635dc69-c7c9-4e4c-89d8-3066f1aa2765/etsy-6.jpg","https://media.gemworkers.com/items/2635dc69-c7c9-4e4c-89d8-3066f1aa2765/etsy-7.jpg","https://media.gemworkers.com/items/2635dc69-c7c9-4e4c-89d8-3066f1aa2765/etsy-8.jpg","https://media.gemworkers.com/items/2635dc69-c7c9-4e4c-89d8-3066f1aa2765/etsy-9.jpg","https://media.gemworkers.com/items/2635dc69-c7c9-4e4c-89d8-3066f1aa2765/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 250 USD, converted at ECB rate. Etsy tags: Tourmaline Jewellery,Tourmaline Earrings,Earrings Stud,y2k earrings stud,Gold Rings,Natural Stone,Gift For Her,Rings For Men,Oceangemsminerals,lagoon tourmaline,tourmaline pairs,bicolour tourmaline,Watermelon Bicolour.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('d0c5f5d1-905e-4d80-8ab1-2ee943924905', '11.1 Cts Watermelon Bicolour Tourmalines', 'Sweet Perfect Watermelon Tourmaline 

Unique And Rare Colour

Very Shiny And High Lustre 

11.10 Cts 
7.4mm to 19.4mm

No treatment.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 893, 1, 'loose_stone', 'Tourmaline', 'Watermelon', 11.1, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/d0c5f5d1-905e-4d80-8ab1-2ee943924905/etsy-1.jpg","https://media.gemworkers.com/items/d0c5f5d1-905e-4d80-8ab1-2ee943924905/etsy-2.jpg","https://media.gemworkers.com/items/d0c5f5d1-905e-4d80-8ab1-2ee943924905/etsy-3.jpg","https://media.gemworkers.com/items/d0c5f5d1-905e-4d80-8ab1-2ee943924905/etsy-4.jpg","https://media.gemworkers.com/items/d0c5f5d1-905e-4d80-8ab1-2ee943924905/etsy-5.jpg","https://media.gemworkers.com/items/d0c5f5d1-905e-4d80-8ab1-2ee943924905/etsy-6.jpg","https://media.gemworkers.com/items/d0c5f5d1-905e-4d80-8ab1-2ee943924905/etsy-7.jpg","https://media.gemworkers.com/items/d0c5f5d1-905e-4d80-8ab1-2ee943924905/etsy-8.jpg","https://media.gemworkers.com/items/d0c5f5d1-905e-4d80-8ab1-2ee943924905/etsy-9.jpg","https://media.gemworkers.com/items/d0c5f5d1-905e-4d80-8ab1-2ee943924905/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 999 USD, converted at ECB rate. Etsy tags: Tourmaline Jewellery,Tourmaline Earrings,Earrings Stud,y2k earrings stud,Gold Rings,Natural Stone,Gift For Her,Rings For Men,Oceangemsminerals,lagoon tourmaline,tourmaline pairs,bicolour tourmaline,Watermelon Bicolour.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('9de37a4e-29ba-4de6-a78d-d93ea68b4507', '4.5 Cts Seafoam Tourmaline', 'Mesmerising Seafoam colour afghan tourmaline 

Ethically sourced 

4.50 Cts 
10.5x10.5x6.6mm

Unheated, Untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 268, 1, 'loose_stone', 'Tourmaline', NULL, 4.5, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/9de37a4e-29ba-4de6-a78d-d93ea68b4507/etsy-1.jpg","https://media.gemworkers.com/items/9de37a4e-29ba-4de6-a78d-d93ea68b4507/etsy-2.jpg","https://media.gemworkers.com/items/9de37a4e-29ba-4de6-a78d-d93ea68b4507/etsy-3.jpg","https://media.gemworkers.com/items/9de37a4e-29ba-4de6-a78d-d93ea68b4507/etsy-4.jpg","https://media.gemworkers.com/items/9de37a4e-29ba-4de6-a78d-d93ea68b4507/etsy-5.jpg","https://media.gemworkers.com/items/9de37a4e-29ba-4de6-a78d-d93ea68b4507/etsy-6.jpg","https://media.gemworkers.com/items/9de37a4e-29ba-4de6-a78d-d93ea68b4507/etsy-7.jpg","https://media.gemworkers.com/items/9de37a4e-29ba-4de6-a78d-d93ea68b4507/etsy-8.jpg","https://media.gemworkers.com/items/9de37a4e-29ba-4de6-a78d-d93ea68b4507/etsy-9.jpg","https://media.gemworkers.com/items/9de37a4e-29ba-4de6-a78d-d93ea68b4507/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 300 USD, converted at ECB rate. Etsy tags: Jewellery Supplies,Jewellery Making,DIY Jewellery Making,Gift For Her,Rings For Men,Rings For Women,Natural Stone,Silver Sterling,Gold Ring,Tourmaline Jewellery,Tourmaline Supplies,Afghan Tourmaline,y2k earrings stud.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('7c964e0f-9167-4d70-87a2-afd393dead7f', '1.4 Cts Bright Pink Tourmaline', 'Natural Bright Pink Tourmaline

Trillion Cut 

1.40 Cts 
7.5x7.5x4.1mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 268, 1, 'loose_stone', 'Tourmaline', NULL, 1.4, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/7c964e0f-9167-4d70-87a2-afd393dead7f/etsy-1.jpg","https://media.gemworkers.com/items/7c964e0f-9167-4d70-87a2-afd393dead7f/etsy-2.jpg","https://media.gemworkers.com/items/7c964e0f-9167-4d70-87a2-afd393dead7f/etsy-3.jpg","https://media.gemworkers.com/items/7c964e0f-9167-4d70-87a2-afd393dead7f/etsy-4.jpg","https://media.gemworkers.com/items/7c964e0f-9167-4d70-87a2-afd393dead7f/etsy-5.jpg","https://media.gemworkers.com/items/7c964e0f-9167-4d70-87a2-afd393dead7f/etsy-6.jpg","https://media.gemworkers.com/items/7c964e0f-9167-4d70-87a2-afd393dead7f/etsy-7.jpg","https://media.gemworkers.com/items/7c964e0f-9167-4d70-87a2-afd393dead7f/etsy-8.jpg","https://media.gemworkers.com/items/7c964e0f-9167-4d70-87a2-afd393dead7f/etsy-9.jpg","https://media.gemworkers.com/items/7c964e0f-9167-4d70-87a2-afd393dead7f/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 300 USD, converted at ECB rate. Etsy tags: trillion Cut,Pink Tourmalines,Tourmaline Set,Pink Tourmaline Set,Orange Tourmaline,Jewellery Making,Jewellery Supplies,Jewellery Findings,Natural Stone,Gold Rings,Tourmaline Lot,Tourmaline Pairs,Loose Gemstones.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('7e97e322-c942-4fd7-b518-44811c0dab48', '1.8 Cts Blue Bicolour Tourmaline', 'Blue Bicolour Tourmaline Emerald Cut 

rare find

1.80 Cts 
11.1x4.4x3.7mm

No Treatment Whatsoever.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 134, 1, 'loose_stone', 'Tourmaline', NULL, 1.8, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/7e97e322-c942-4fd7-b518-44811c0dab48/etsy-1.jpg","https://media.gemworkers.com/items/7e97e322-c942-4fd7-b518-44811c0dab48/etsy-2.jpg","https://media.gemworkers.com/items/7e97e322-c942-4fd7-b518-44811c0dab48/etsy-3.jpg","https://media.gemworkers.com/items/7e97e322-c942-4fd7-b518-44811c0dab48/etsy-4.jpg","https://media.gemworkers.com/items/7e97e322-c942-4fd7-b518-44811c0dab48/etsy-5.jpg","https://media.gemworkers.com/items/7e97e322-c942-4fd7-b518-44811c0dab48/etsy-6.jpg","https://media.gemworkers.com/items/7e97e322-c942-4fd7-b518-44811c0dab48/etsy-7.jpg","https://media.gemworkers.com/items/7e97e322-c942-4fd7-b518-44811c0dab48/etsy-8.jpg","https://media.gemworkers.com/items/7e97e322-c942-4fd7-b518-44811c0dab48/etsy-9.jpg","https://media.gemworkers.com/items/7e97e322-c942-4fd7-b518-44811c0dab48/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 150 USD, converted at ECB rate. Etsy tags: Emerald Cut,EmeraldCutTourmaline,Jewellery making,earrings stud,Tourmaline Lot,Blue Tourmaline,Lagoon Tourmaline,Neon Blue,neon blue tourmaline,Rings For Men,Tourmalines,Ink Blue Tourmaline,Oceangemsminerals.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('a32c0207-e07d-4ef4-ba55-5891a52771b0', '3 Cts Vibrant Green Tourmaline', 'Beautiful Top Green Afghan Tourmaline

Vibrant Colour

Perfectly Cut

Loupe Clean

3 Cts 
16.8x4.5x3.6mm

Unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 294, 1, 'loose_stone', 'Tourmaline', NULL, 3, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/a32c0207-e07d-4ef4-ba55-5891a52771b0/etsy-1.jpg","https://media.gemworkers.com/items/a32c0207-e07d-4ef4-ba55-5891a52771b0/etsy-2.jpg","https://media.gemworkers.com/items/a32c0207-e07d-4ef4-ba55-5891a52771b0/etsy-3.jpg","https://media.gemworkers.com/items/a32c0207-e07d-4ef4-ba55-5891a52771b0/etsy-4.jpg","https://media.gemworkers.com/items/a32c0207-e07d-4ef4-ba55-5891a52771b0/etsy-5.jpg","https://media.gemworkers.com/items/a32c0207-e07d-4ef4-ba55-5891a52771b0/etsy-6.jpg","https://media.gemworkers.com/items/a32c0207-e07d-4ef4-ba55-5891a52771b0/etsy-7.jpg","https://media.gemworkers.com/items/a32c0207-e07d-4ef4-ba55-5891a52771b0/etsy-8.jpg","https://media.gemworkers.com/items/a32c0207-e07d-4ef4-ba55-5891a52771b0/etsy-9.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 329 USD, converted at ECB rate. Etsy tags: Green Tourmaline,Vibrant Tourmaline,AppleGreenTourmaline,Tourmaline jewellery,jewellers,jewellery making,jewellery supplies,jewellery findings,Oceangemsminerals,rings for women,rings for men,rings jewellery,natural stone.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('4a5a7c9f-d010-4d34-9587-a006a0d37179', '8.40 Cts Rubilite Tourmaline Lot', 'Gorgeous Rubilite Tourmaline Lot

8.40 Cts
10.3 to 4.8mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 161, 1, 'loose_stone', 'Tourmaline', 'Rubellite', 8.4, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/4a5a7c9f-d010-4d34-9587-a006a0d37179/etsy-1.jpg","https://media.gemworkers.com/items/4a5a7c9f-d010-4d34-9587-a006a0d37179/etsy-2.jpg","https://media.gemworkers.com/items/4a5a7c9f-d010-4d34-9587-a006a0d37179/etsy-3.jpg","https://media.gemworkers.com/items/4a5a7c9f-d010-4d34-9587-a006a0d37179/etsy-4.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 180 USD, converted at ECB rate. Etsy tags: Red Rubilite,PigeonBlood Rubilite,Orange Rubilite,Pinkish Rubilite,Red Tourmaline,Pink Tourmaline,Orange Tourmaline,Cushion Cut,Tourmaline Jewellery,Tourmaline Faceted,Rubilite Tourmaline,Jewellery Making,Jewellery Findings.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('e00e8270-9ad0-47e6-a113-4418ce89558f', '7.45 Cts Rubilite Tourmaline Lot', 'Gorgeous Rubilite Tourmaline Lot

7.45 Cts
9.6 to 4.2mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 161, 1, 'loose_stone', 'Tourmaline', 'Rubellite', 7.45, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/e00e8270-9ad0-47e6-a113-4418ce89558f/etsy-1.jpg","https://media.gemworkers.com/items/e00e8270-9ad0-47e6-a113-4418ce89558f/etsy-2.jpg","https://media.gemworkers.com/items/e00e8270-9ad0-47e6-a113-4418ce89558f/etsy-3.jpg","https://media.gemworkers.com/items/e00e8270-9ad0-47e6-a113-4418ce89558f/etsy-4.jpg","https://media.gemworkers.com/items/e00e8270-9ad0-47e6-a113-4418ce89558f/etsy-5.jpg","https://media.gemworkers.com/items/e00e8270-9ad0-47e6-a113-4418ce89558f/etsy-6.jpg","https://media.gemworkers.com/items/e00e8270-9ad0-47e6-a113-4418ce89558f/etsy-7.jpg","https://media.gemworkers.com/items/e00e8270-9ad0-47e6-a113-4418ce89558f/etsy-8.jpg","https://media.gemworkers.com/items/e00e8270-9ad0-47e6-a113-4418ce89558f/etsy-9.jpg","https://media.gemworkers.com/items/e00e8270-9ad0-47e6-a113-4418ce89558f/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 180 USD, converted at ECB rate. Etsy tags: Red Rubilite,PigeonBlood Rubilite,Orange Rubilite,Pinkish Rubilite,Red Tourmaline,Pink Tourmaline,Orange Tourmaline,Cushion Cut,Tourmaline Jewellery,Tourmaline Faceted,Rubilite Tourmaline,Jewellery Making,Jewellery Findings.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('604295ba-6adc-406e-b157-dbea66b48276', '12.75 Cts Rare Bicolour Tourmaline Lot', 'Top Quality Bicolour Tourmaline 

Best and vibrant colour 

12.75 Cts
27.3 to 7.3mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 356, 1, 'loose_stone', 'Tourmaline', NULL, 12.75, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/604295ba-6adc-406e-b157-dbea66b48276/etsy-1.jpg","https://media.gemworkers.com/items/604295ba-6adc-406e-b157-dbea66b48276/etsy-2.jpg","https://media.gemworkers.com/items/604295ba-6adc-406e-b157-dbea66b48276/etsy-3.jpg","https://media.gemworkers.com/items/604295ba-6adc-406e-b157-dbea66b48276/etsy-4.jpg","https://media.gemworkers.com/items/604295ba-6adc-406e-b157-dbea66b48276/etsy-5.jpg","https://media.gemworkers.com/items/604295ba-6adc-406e-b157-dbea66b48276/etsy-6.jpg","https://media.gemworkers.com/items/604295ba-6adc-406e-b157-dbea66b48276/etsy-7.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 399 USD, converted at ECB rate. Etsy tags: Tourmaline Lot,Tourmaline Jewellery,Bluegreen Tourmaline,Lagoon Tourmaline,Blue Tourmaline,Green Tourmaline,Seafoam Tourmaline,Bicolour Tourmaline,Oceangemsminerals,Mint Tourmaline,Vivid Tourmaline Lot,Tourmaline Supplies,Jewellers.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('103b8008-ba22-4182-91c9-dd3bc92edc19', '3.40 Cts Rubilite Tourmaline', 'Gorgeous Pegeon Blood 🩸Colour Rubilite Tourmaline best for ring 💍 

3.40 Cts
9.3 x 8.1 x 5.1mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 304, 1, 'loose_stone', 'Tourmaline', 'Rubellite', 3.4, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/103b8008-ba22-4182-91c9-dd3bc92edc19/etsy-1.jpg","https://media.gemworkers.com/items/103b8008-ba22-4182-91c9-dd3bc92edc19/etsy-2.jpg","https://media.gemworkers.com/items/103b8008-ba22-4182-91c9-dd3bc92edc19/etsy-3.jpg","https://media.gemworkers.com/items/103b8008-ba22-4182-91c9-dd3bc92edc19/etsy-4.jpg","https://media.gemworkers.com/items/103b8008-ba22-4182-91c9-dd3bc92edc19/etsy-5.jpg","https://media.gemworkers.com/items/103b8008-ba22-4182-91c9-dd3bc92edc19/etsy-6.jpg","https://media.gemworkers.com/items/103b8008-ba22-4182-91c9-dd3bc92edc19/etsy-7.jpg","https://media.gemworkers.com/items/103b8008-ba22-4182-91c9-dd3bc92edc19/etsy-8.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 340 USD, converted at ECB rate. Etsy tags: Red Rubilite,PigeonBlood Rubilite,Orange Rubilite,Pinkish Rubilite,Red Tourmaline,Pink Tourmaline,Orange Tourmaline,Cushion Cut,Tourmaline Jewellery,Tourmaline Faceted,Rubilite Tourmaline,Jewellery Making,Jewellery Findings.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('a58aaa44-50c0-478a-bbcb-f434d634af09', '7.35 Cts Electric Neon Blue Green Tourmaline', 'Top Quality Electric Vibrant Neon Blue And Neon Green Mix Colour Tourmaline 

Best and vibrant colour 

Exceptional Colour 

Very Rare

7.35 Cts
11.8 x 10 x 8.3mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 1313, 1, 'loose_stone', 'Tourmaline', NULL, 7.35, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/a58aaa44-50c0-478a-bbcb-f434d634af09/etsy-1.jpg","https://media.gemworkers.com/items/a58aaa44-50c0-478a-bbcb-f434d634af09/etsy-2.jpg","https://media.gemworkers.com/items/a58aaa44-50c0-478a-bbcb-f434d634af09/etsy-3.jpg","https://media.gemworkers.com/items/a58aaa44-50c0-478a-bbcb-f434d634af09/etsy-4.jpg","https://media.gemworkers.com/items/a58aaa44-50c0-478a-bbcb-f434d634af09/etsy-5.jpg","https://media.gemworkers.com/items/a58aaa44-50c0-478a-bbcb-f434d634af09/etsy-6.jpg","https://media.gemworkers.com/items/a58aaa44-50c0-478a-bbcb-f434d634af09/etsy-7.jpg","https://media.gemworkers.com/items/a58aaa44-50c0-478a-bbcb-f434d634af09/etsy-8.jpg","https://media.gemworkers.com/items/a58aaa44-50c0-478a-bbcb-f434d634af09/etsy-9.jpg","https://media.gemworkers.com/items/a58aaa44-50c0-478a-bbcb-f434d634af09/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 1470 USD, converted at ECB rate. Etsy tags: Tourmaline Lot,Tourmaline Jewellery,Bluegreen Tourmaline,Lagoon Tourmaline,Blue Tourmaline,Green Tourmaline,Seafoam Tourmaline,Bicolour Tourmaline,Oceangemsminerals,Mint Tourmaline,Vivid Tourmaline Lot,Tourmaline Supplies,Jewellers.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('9ee551fd-af83-413a-a3fc-d244a70b6013', '8.65 Cts Unique Bicolour Tourmalines', 'Afghan Unique Bicolour tourmalines

At very reasonable price 

Ethically Sourced 

8.65 Cts
10.7 to 16mm

Unheated,Untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 214, 1, 'loose_stone', 'Tourmaline', NULL, 8.65, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/9ee551fd-af83-413a-a3fc-d244a70b6013/etsy-1.jpg","https://media.gemworkers.com/items/9ee551fd-af83-413a-a3fc-d244a70b6013/etsy-2.jpg","https://media.gemworkers.com/items/9ee551fd-af83-413a-a3fc-d244a70b6013/etsy-3.jpg","https://media.gemworkers.com/items/9ee551fd-af83-413a-a3fc-d244a70b6013/etsy-4.jpg","https://media.gemworkers.com/items/9ee551fd-af83-413a-a3fc-d244a70b6013/etsy-5.jpg","https://media.gemworkers.com/items/9ee551fd-af83-413a-a3fc-d244a70b6013/etsy-6.jpg","https://media.gemworkers.com/items/9ee551fd-af83-413a-a3fc-d244a70b6013/etsy-7.jpg","https://media.gemworkers.com/items/9ee551fd-af83-413a-a3fc-d244a70b6013/etsy-8.jpg","https://media.gemworkers.com/items/9ee551fd-af83-413a-a3fc-d244a70b6013/etsy-9.jpg","https://media.gemworkers.com/items/9ee551fd-af83-413a-a3fc-d244a70b6013/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 240 USD, converted at ECB rate. Etsy tags: tourmaline,jewellery,tourmaline pair,earrings,tourmaline jewellery,bicolour tourmaline,y2k earrings stud,Jewellery Making,Jewellery Findings,Jewellery Supplies,Natural Stone,Tourmaline Earrings,Loose Gemstones.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('d4a448f5-168e-4f0b-abb1-afafcff8f392', '11.8 Cts Unique Bicolour Tourmalines', 'Afghan Unique Bicolour tourmalines

At very reasonable price 

Ethically Sourced 

11.80 Cts
13 to 15.8mm

Unheated,Untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 179, 1, 'loose_stone', 'Tourmaline', NULL, 11.8, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/d4a448f5-168e-4f0b-abb1-afafcff8f392/etsy-1.jpg","https://media.gemworkers.com/items/d4a448f5-168e-4f0b-abb1-afafcff8f392/etsy-2.jpg","https://media.gemworkers.com/items/d4a448f5-168e-4f0b-abb1-afafcff8f392/etsy-3.jpg","https://media.gemworkers.com/items/d4a448f5-168e-4f0b-abb1-afafcff8f392/etsy-4.jpg","https://media.gemworkers.com/items/d4a448f5-168e-4f0b-abb1-afafcff8f392/etsy-5.jpg","https://media.gemworkers.com/items/d4a448f5-168e-4f0b-abb1-afafcff8f392/etsy-6.jpg","https://media.gemworkers.com/items/d4a448f5-168e-4f0b-abb1-afafcff8f392/etsy-7.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 200 USD, converted at ECB rate. Etsy tags: tourmaline,jewellery,tourmaline pair,earrings,tourmaline jewellery,bicolour tourmaline,y2k earrings stud,Jewellery Making,Jewellery Findings,Jewellery Supplies,Natural Stone,Tourmaline Earrings,Loose Gemstones.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('6695dc52-4087-4278-ab80-dfd140767b08', '15.85 Cts Green Tourmaline Lot', 'Step Cushion Cut Afghan Tourmalines

15.85 Cts
9.2 to 4.6mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 214, 1, 'loose_stone', 'Tourmaline', NULL, 15.85, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/6695dc52-4087-4278-ab80-dfd140767b08/etsy-1.jpg","https://media.gemworkers.com/items/6695dc52-4087-4278-ab80-dfd140767b08/etsy-2.jpg","https://media.gemworkers.com/items/6695dc52-4087-4278-ab80-dfd140767b08/etsy-3.jpg","https://media.gemworkers.com/items/6695dc52-4087-4278-ab80-dfd140767b08/etsy-4.jpg","https://media.gemworkers.com/items/6695dc52-4087-4278-ab80-dfd140767b08/etsy-5.jpg","https://media.gemworkers.com/items/6695dc52-4087-4278-ab80-dfd140767b08/etsy-6.jpg","https://media.gemworkers.com/items/6695dc52-4087-4278-ab80-dfd140767b08/etsy-7.jpg","https://media.gemworkers.com/items/6695dc52-4087-4278-ab80-dfd140767b08/etsy-8.jpg","https://media.gemworkers.com/items/6695dc52-4087-4278-ab80-dfd140767b08/etsy-9.jpg","https://media.gemworkers.com/items/6695dc52-4087-4278-ab80-dfd140767b08/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 240 USD, converted at ECB rate. Etsy tags: Paraiba Tourmaline,Paraiba Colour,Lagoon Tourmaline,Bluegreen Tourmaline,Blue Tourmaline,Neon Blue Tourmaline,Tourmaline Jewellery,Lagoon Colour,Oceangemsminerals,Ink Blue Tourmaline,Wedding Rings,Rings For Women,Cushion Cut.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('ce2bb3ed-9fed-4d5f-99c0-960c5ef8c57f', '0.85 Cts Neon Blue Bicolour Tourmaline Pairs', 'Top Quality Neon Blue Bicolour Tourmaline Emerald Cut Pairs

rare find

0.85 Cts
5.5 x 2 x 1.5mm
4.7 x 2 x 1.7mm

No Treatment Whatsoever.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 147, 1, 'loose_stone', 'Tourmaline', NULL, 0.85, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/ce2bb3ed-9fed-4d5f-99c0-960c5ef8c57f/etsy-1.jpg","https://media.gemworkers.com/items/ce2bb3ed-9fed-4d5f-99c0-960c5ef8c57f/etsy-2.jpg","https://media.gemworkers.com/items/ce2bb3ed-9fed-4d5f-99c0-960c5ef8c57f/etsy-3.jpg","https://media.gemworkers.com/items/ce2bb3ed-9fed-4d5f-99c0-960c5ef8c57f/etsy-4.jpg","https://media.gemworkers.com/items/ce2bb3ed-9fed-4d5f-99c0-960c5ef8c57f/etsy-5.jpg","https://media.gemworkers.com/items/ce2bb3ed-9fed-4d5f-99c0-960c5ef8c57f/etsy-6.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 165 USD, converted at ECB rate. Etsy tags: Emerald Cut,EmeraldCutTourmaline,Jewellery making,earrings stud,Tourmaline Lot,Blue Tourmaline,Lagoon Tourmaline,Neon Blue,neon blue tourmaline,Rings For Men,Tourmalines,Ink Blue Tourmaline,Oceangemsminerals.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('d8813ba2-7cd0-4c51-af09-7bd5afd6c310', '4 Cts Unique Tourmalines', 'Rare Tourmaline Bright Colour Best Cut

4 Cts
5.5 to 7.1mm

Unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 223, 1, 'loose_stone', 'Tourmaline', NULL, 4, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/d8813ba2-7cd0-4c51-af09-7bd5afd6c310/etsy-1.jpg","https://media.gemworkers.com/items/d8813ba2-7cd0-4c51-af09-7bd5afd6c310/etsy-2.jpg","https://media.gemworkers.com/items/d8813ba2-7cd0-4c51-af09-7bd5afd6c310/etsy-3.jpg","https://media.gemworkers.com/items/d8813ba2-7cd0-4c51-af09-7bd5afd6c310/etsy-4.jpg","https://media.gemworkers.com/items/d8813ba2-7cd0-4c51-af09-7bd5afd6c310/etsy-5.jpg","https://media.gemworkers.com/items/d8813ba2-7cd0-4c51-af09-7bd5afd6c310/etsy-6.jpg","https://media.gemworkers.com/items/d8813ba2-7cd0-4c51-af09-7bd5afd6c310/etsy-7.jpg","https://media.gemworkers.com/items/d8813ba2-7cd0-4c51-af09-7bd5afd6c310/etsy-8.jpg","https://media.gemworkers.com/items/d8813ba2-7cd0-4c51-af09-7bd5afd6c310/etsy-9.jpg","https://media.gemworkers.com/items/d8813ba2-7cd0-4c51-af09-7bd5afd6c310/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 250 USD, converted at ECB rate. Etsy tags: Lagoon Tourmaline,Blue Tourmaline,Neon Blue Tourmaline,Neon Tourmaline,Rare Tourmaline,Tourmaline Jewellery,Oceangemsminerals,Jewellery Making,Jewellery Supplies,jewellery findings,Unique Tourmaline,Tourmaline Rings,Gold Rings.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('7c56400a-4f62-405f-a336-f13f91d2fad6', '8.15 Cts Seafoam Tourmaline lot', 'Mesmerising Seafoam Blue colour afghan tourmaline 

Ethically sourced 

 lustre and brilliance 

8.15 Cts
10.5 to 4.9mm

Unheated, Untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 178, 1, 'loose_stone', 'Tourmaline', NULL, 8.15, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/7c56400a-4f62-405f-a336-f13f91d2fad6/etsy-1.jpg","https://media.gemworkers.com/items/7c56400a-4f62-405f-a336-f13f91d2fad6/etsy-2.jpg","https://media.gemworkers.com/items/7c56400a-4f62-405f-a336-f13f91d2fad6/etsy-3.jpg","https://media.gemworkers.com/items/7c56400a-4f62-405f-a336-f13f91d2fad6/etsy-4.jpg","https://media.gemworkers.com/items/7c56400a-4f62-405f-a336-f13f91d2fad6/etsy-5.jpg","https://media.gemworkers.com/items/7c56400a-4f62-405f-a336-f13f91d2fad6/etsy-6.jpg","https://media.gemworkers.com/items/7c56400a-4f62-405f-a336-f13f91d2fad6/etsy-7.jpg","https://media.gemworkers.com/items/7c56400a-4f62-405f-a336-f13f91d2fad6/etsy-8.jpg","https://media.gemworkers.com/items/7c56400a-4f62-405f-a336-f13f91d2fad6/etsy-9.jpg","https://media.gemworkers.com/items/7c56400a-4f62-405f-a336-f13f91d2fad6/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 199 USD, converted at ECB rate. Etsy tags: Jewellery Supplies,Jewellery Making,DIY Jewellery Making,Gift For Her,Rings For Men,Natural Stone,Silver Sterling,Gold Ring,Tourmaline Jewellery,Tourmaline Supplies,Afghan Tourmaline,y2k earrings stud,Seafoam Tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('44ea5659-99dd-4121-8fd4-3f8799a3a3bb', '9.5 Cts Seafoam Tourmaline lot', 'Mesmerising Seafoam Blue colour afghan tourmaline 

Ethically sourced 

 lustre and brilliance 

9.50 Cts
12 to 4.4mm

Unheated, Untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 178, 1, 'loose_stone', 'Tourmaline', NULL, 9.5, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/44ea5659-99dd-4121-8fd4-3f8799a3a3bb/etsy-1.jpg","https://media.gemworkers.com/items/44ea5659-99dd-4121-8fd4-3f8799a3a3bb/etsy-2.jpg","https://media.gemworkers.com/items/44ea5659-99dd-4121-8fd4-3f8799a3a3bb/etsy-3.jpg","https://media.gemworkers.com/items/44ea5659-99dd-4121-8fd4-3f8799a3a3bb/etsy-4.jpg","https://media.gemworkers.com/items/44ea5659-99dd-4121-8fd4-3f8799a3a3bb/etsy-5.jpg","https://media.gemworkers.com/items/44ea5659-99dd-4121-8fd4-3f8799a3a3bb/etsy-6.jpg","https://media.gemworkers.com/items/44ea5659-99dd-4121-8fd4-3f8799a3a3bb/etsy-7.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 199 USD, converted at ECB rate. Etsy tags: Jewellery Supplies,Jewellery Making,DIY Jewellery Making,Gift For Her,Rings For Men,Natural Stone,Silver Sterling,Gold Ring,Tourmaline Jewellery,Tourmaline Supplies,Afghan Tourmaline,y2k earrings stud,Seafoam Tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('0ca4aeb0-e5fe-43ce-bb95-76d9441f64de', '7.35 Cts Rare Bicolour Tourmaline', 'Top Quality Bicolour Tourmaline 

Best and vibrant colour 

7.35 Cts
15.1 x 7.5 x 6.4mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 893, 1, 'loose_stone', 'Tourmaline', NULL, 7.35, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/0ca4aeb0-e5fe-43ce-bb95-76d9441f64de/etsy-1.jpg","https://media.gemworkers.com/items/0ca4aeb0-e5fe-43ce-bb95-76d9441f64de/etsy-2.jpg","https://media.gemworkers.com/items/0ca4aeb0-e5fe-43ce-bb95-76d9441f64de/etsy-3.jpg","https://media.gemworkers.com/items/0ca4aeb0-e5fe-43ce-bb95-76d9441f64de/etsy-4.jpg","https://media.gemworkers.com/items/0ca4aeb0-e5fe-43ce-bb95-76d9441f64de/etsy-5.jpg","https://media.gemworkers.com/items/0ca4aeb0-e5fe-43ce-bb95-76d9441f64de/etsy-6.jpg","https://media.gemworkers.com/items/0ca4aeb0-e5fe-43ce-bb95-76d9441f64de/etsy-7.jpg","https://media.gemworkers.com/items/0ca4aeb0-e5fe-43ce-bb95-76d9441f64de/etsy-8.jpg","https://media.gemworkers.com/items/0ca4aeb0-e5fe-43ce-bb95-76d9441f64de/etsy-9.jpg","https://media.gemworkers.com/items/0ca4aeb0-e5fe-43ce-bb95-76d9441f64de/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 999 USD, converted at ECB rate. Etsy tags: Tourmaline Lot,Tourmaline Jewellery,Bluegreen Tourmaline,Lagoon Tourmaline,Blue Tourmaline,Green Tourmaline,Seafoam Tourmaline,Bicolour Tourmaline,Oceangemsminerals,Mint Tourmaline,Vivid Tourmaline Lot,Tourmaline Supplies,Jewellers.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('f60689b4-5979-4a7e-87b2-e8ba4b57f1bf', '2.20 Cts Trillion Cut Tourmalines', 'Natural Afghan Tourmalines

Trillion Cut 

2.20 Cts
4.9 x 4.8 x 3.2mm

Unheated, Untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 178, 1, 'loose_stone', 'Tourmaline', NULL, 2.2, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/f60689b4-5979-4a7e-87b2-e8ba4b57f1bf/etsy-1.jpg","https://media.gemworkers.com/items/f60689b4-5979-4a7e-87b2-e8ba4b57f1bf/etsy-2.jpg","https://media.gemworkers.com/items/f60689b4-5979-4a7e-87b2-e8ba4b57f1bf/etsy-3.jpg","https://media.gemworkers.com/items/f60689b4-5979-4a7e-87b2-e8ba4b57f1bf/etsy-4.jpg","https://media.gemworkers.com/items/f60689b4-5979-4a7e-87b2-e8ba4b57f1bf/etsy-5.jpg","https://media.gemworkers.com/items/f60689b4-5979-4a7e-87b2-e8ba4b57f1bf/etsy-6.jpg","https://media.gemworkers.com/items/f60689b4-5979-4a7e-87b2-e8ba4b57f1bf/etsy-7.jpg","https://media.gemworkers.com/items/f60689b4-5979-4a7e-87b2-e8ba4b57f1bf/etsy-8.jpg","https://media.gemworkers.com/items/f60689b4-5979-4a7e-87b2-e8ba4b57f1bf/etsy-9.jpg","https://media.gemworkers.com/items/f60689b4-5979-4a7e-87b2-e8ba4b57f1bf/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 199 USD, converted at ECB rate. Etsy tags: trillion Cut,Pink Tourmalines,Tourmaline Set,Pink Tourmaline Set,Orange Tourmaline,Jewellery Making,Jewellery Supplies,Jewellery Findings,Natural Stone,Gold Rings,Tourmaline Lot,Tourmaline Pairs,Loose Gemstones.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('e6c39608-8363-48c6-9c78-672afd0f97af', '8.6 Cts Tourmaline Lot', 'Gorgeous Tourmaline Lot 

Eye Clean and good lustre

8.60 Cts
4 to 11mm

100% Natural No treatment whatsoever', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 304, 1, 'loose_stone', 'Tourmaline', NULL, 8.6, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/e6c39608-8363-48c6-9c78-672afd0f97af/etsy-1.jpg","https://media.gemworkers.com/items/e6c39608-8363-48c6-9c78-672afd0f97af/etsy-2.jpg","https://media.gemworkers.com/items/e6c39608-8363-48c6-9c78-672afd0f97af/etsy-3.jpg","https://media.gemworkers.com/items/e6c39608-8363-48c6-9c78-672afd0f97af/etsy-4.jpg","https://media.gemworkers.com/items/e6c39608-8363-48c6-9c78-672afd0f97af/etsy-5.jpg","https://media.gemworkers.com/items/e6c39608-8363-48c6-9c78-672afd0f97af/etsy-6.jpg","https://media.gemworkers.com/items/e6c39608-8363-48c6-9c78-672afd0f97af/etsy-7.jpg","https://media.gemworkers.com/items/e6c39608-8363-48c6-9c78-672afd0f97af/etsy-8.jpg","https://media.gemworkers.com/items/e6c39608-8363-48c6-9c78-672afd0f97af/etsy-9.jpg","https://media.gemworkers.com/items/e6c39608-8363-48c6-9c78-672afd0f97af/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 340 USD, converted at ECB rate. Etsy tags: Tourmaline Earrings,Jewellery Making,Jewellery Findings,y2k earrings stud,Earrings findings,emerald cut,bicolour tourmaline,Tourmaline Pairs,gift for her,Natural Stone,blue tourmaline lot,Oceangemsminerals,Clean Tourmaline. Had variations on Etsy — check size/options.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('c1a9b418-c1ce-4666-811e-978137905614', '8.50Cts,blue and Green Tourmaline Lot', 'Blue and Green Afghan Tourmaline Lot 

Cushion Cut.

High Lustre And Good Colours.

8.50 carats 
6x5x4.5 to 6.5x6.5x5mm

Unheated,Untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 223, 1, 'loose_stone', 'Tourmaline', NULL, 8.5, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/c1a9b418-c1ce-4666-811e-978137905614/etsy-1.jpg","https://media.gemworkers.com/items/c1a9b418-c1ce-4666-811e-978137905614/etsy-2.jpg","https://media.gemworkers.com/items/c1a9b418-c1ce-4666-811e-978137905614/etsy-3.jpg","https://media.gemworkers.com/items/c1a9b418-c1ce-4666-811e-978137905614/etsy-4.jpg","https://media.gemworkers.com/items/c1a9b418-c1ce-4666-811e-978137905614/etsy-5.jpg","https://media.gemworkers.com/items/c1a9b418-c1ce-4666-811e-978137905614/etsy-6.jpg","https://media.gemworkers.com/items/c1a9b418-c1ce-4666-811e-978137905614/etsy-7.jpg","https://media.gemworkers.com/items/c1a9b418-c1ce-4666-811e-978137905614/etsy-8.jpg","https://media.gemworkers.com/items/c1a9b418-c1ce-4666-811e-978137905614/etsy-9.jpg","https://media.gemworkers.com/items/c1a9b418-c1ce-4666-811e-978137905614/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 250 USD, converted at ECB rate. Etsy tags: Jewellery Making,Jewellery Supplies,Gemstones Jewellery,Jewellery Findings,Gift for her,Rings For Women,Rings For Men,Gold Rings,Jewels,Bluegreen tourmaline,neon tourmaline,lagoon tourmaline,mintgreentourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('0798f5d8-09f8-4336-ae5e-d453d96d38c3', '2.80 Carat Afghan Chrome Tourmaline Gemstone', 'Gorgeous Mesmerising Chrome Cool Colour Afghan Tourmaline 

One Of A Kind, Brilliance And Lustre.

1.80 carats 
6.8x6x5mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 161, 1, 'loose_stone', 'Tourmaline', NULL, 2.8, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/0798f5d8-09f8-4336-ae5e-d453d96d38c3/etsy-1.jpg","https://media.gemworkers.com/items/0798f5d8-09f8-4336-ae5e-d453d96d38c3/etsy-2.jpg","https://media.gemworkers.com/items/0798f5d8-09f8-4336-ae5e-d453d96d38c3/etsy-3.jpg","https://media.gemworkers.com/items/0798f5d8-09f8-4336-ae5e-d453d96d38c3/etsy-4.jpg","https://media.gemworkers.com/items/0798f5d8-09f8-4336-ae5e-d453d96d38c3/etsy-5.jpg","https://media.gemworkers.com/items/0798f5d8-09f8-4336-ae5e-d453d96d38c3/etsy-6.jpg","https://media.gemworkers.com/items/0798f5d8-09f8-4336-ae5e-d453d96d38c3/etsy-7.jpg","https://media.gemworkers.com/items/0798f5d8-09f8-4336-ae5e-d453d96d38c3/etsy-8.jpg","https://media.gemworkers.com/items/0798f5d8-09f8-4336-ae5e-d453d96d38c3/etsy-9.jpg","https://media.gemworkers.com/items/0798f5d8-09f8-4336-ae5e-d453d96d38c3/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 180 USD, converted at ECB rate. Etsy tags: Tourmaline Jewellery,Jewellery Supplies,Jewellery Making,Jewellery Findings,Tourmaline Earrings,Earrings Stud,y2k earrings stud,Gold Rings,Natural Stone,Gift For Her,Rings For Men,Rings For Women,Chrome Tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('958fdb4c-fd15-4655-b475-9e49921e32b4', '2.80Cts,Seafoam Blue Tourmalines', 'Seafoam Blue Tourmalines

Imagine These Two in one ring 💍 

high lustre and brilliance, Excellent Cut and polish.

2.80 carats 
Smaller:5.5x4.9x4mm
Longer:7x5x4mm

eye clean to loupe clean.

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 232, 1, 'loose_stone', 'Tourmaline', NULL, 2.8, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/958fdb4c-fd15-4655-b475-9e49921e32b4/etsy-1.jpg","https://media.gemworkers.com/items/958fdb4c-fd15-4655-b475-9e49921e32b4/etsy-2.jpg","https://media.gemworkers.com/items/958fdb4c-fd15-4655-b475-9e49921e32b4/etsy-3.jpg","https://media.gemworkers.com/items/958fdb4c-fd15-4655-b475-9e49921e32b4/etsy-4.jpg","https://media.gemworkers.com/items/958fdb4c-fd15-4655-b475-9e49921e32b4/etsy-5.jpg","https://media.gemworkers.com/items/958fdb4c-fd15-4655-b475-9e49921e32b4/etsy-6.jpg","https://media.gemworkers.com/items/958fdb4c-fd15-4655-b475-9e49921e32b4/etsy-7.jpg","https://media.gemworkers.com/items/958fdb4c-fd15-4655-b475-9e49921e32b4/etsy-8.jpg","https://media.gemworkers.com/items/958fdb4c-fd15-4655-b475-9e49921e32b4/etsy-9.jpg","https://media.gemworkers.com/items/958fdb4c-fd15-4655-b475-9e49921e32b4/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 260 USD, converted at ECB rate. Etsy tags: Seafoam Tourmaline,Loose Gemstones,Jewellery making,jewellery supplies,jewellery findings,gift for her,natural stone,Handmadejewellery,jewels,Tourmaline Jewellery,Tourmaline Lots,Blue Tourmaline,Neon Tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('4a79c51f-8cec-4193-a0c1-9c94f651cf7e', '12.4 Cts Tourmaline Lot', 'Gorgeous Tourmaline Lot

Included but good lustre

12.40 Cts
4 to 12mm

100% Natural No treatment whatsoever', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 179, 1, 'loose_stone', 'Tourmaline', NULL, 12.4, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/4a79c51f-8cec-4193-a0c1-9c94f651cf7e/etsy-1.jpg","https://media.gemworkers.com/items/4a79c51f-8cec-4193-a0c1-9c94f651cf7e/etsy-2.jpg","https://media.gemworkers.com/items/4a79c51f-8cec-4193-a0c1-9c94f651cf7e/etsy-3.jpg","https://media.gemworkers.com/items/4a79c51f-8cec-4193-a0c1-9c94f651cf7e/etsy-4.jpg","https://media.gemworkers.com/items/4a79c51f-8cec-4193-a0c1-9c94f651cf7e/etsy-5.jpg","https://media.gemworkers.com/items/4a79c51f-8cec-4193-a0c1-9c94f651cf7e/etsy-6.jpg","https://media.gemworkers.com/items/4a79c51f-8cec-4193-a0c1-9c94f651cf7e/etsy-7.jpg","https://media.gemworkers.com/items/4a79c51f-8cec-4193-a0c1-9c94f651cf7e/etsy-8.jpg","https://media.gemworkers.com/items/4a79c51f-8cec-4193-a0c1-9c94f651cf7e/etsy-9.jpg","https://media.gemworkers.com/items/4a79c51f-8cec-4193-a0c1-9c94f651cf7e/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 200 USD, converted at ECB rate. Etsy tags: Tourmaline Earrings,Jewellery Making,Jewellery Findings,y2k earrings stud,Earrings findings,emerald cut,bicolour tourmaline,Tourmaline Pairs,gift for her,Natural Stone,stud earrings,blue tourmaline lot,Oceangemsminerals. Had variations on Etsy — check size/options.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('2513906a-b587-48bd-954a-f3f856b94931', '3.10Cts, Lagoon Bicolour Tourmaline', 'Gorgeous Mesmerising Bicolour Lagoon Green Natural Afghanistan Tourmaline 

More beautiful In real, One of a kind

High quality , Glowing Lustre.

3.10 carats 
8.5x8x6mm

unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 214, 1, 'loose_stone', 'Tourmaline', NULL, 3.1, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/2513906a-b587-48bd-954a-f3f856b94931/etsy-1.jpg","https://media.gemworkers.com/items/2513906a-b587-48bd-954a-f3f856b94931/etsy-2.jpg","https://media.gemworkers.com/items/2513906a-b587-48bd-954a-f3f856b94931/etsy-3.jpg","https://media.gemworkers.com/items/2513906a-b587-48bd-954a-f3f856b94931/etsy-4.jpg","https://media.gemworkers.com/items/2513906a-b587-48bd-954a-f3f856b94931/etsy-5.jpg","https://media.gemworkers.com/items/2513906a-b587-48bd-954a-f3f856b94931/etsy-6.jpg","https://media.gemworkers.com/items/2513906a-b587-48bd-954a-f3f856b94931/etsy-7.jpg","https://media.gemworkers.com/items/2513906a-b587-48bd-954a-f3f856b94931/etsy-8.jpg","https://media.gemworkers.com/items/2513906a-b587-48bd-954a-f3f856b94931/etsy-9.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 240 USD, converted at ECB rate. Etsy tags: Jewellery Supplies,Jewellery Making,Gold Rings,Rings For Men,Rings For Women,y2k earrings stud,Gift For Her,Tourmaline Jewellery,Natural Stone,Stud Earrings,Jewellery Stud,bicolour Tourmaline,Lagoon tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('e765505a-720a-4723-a019-774086d50ebf', '2.60 Cts Rubilite Tourmaline', 'Gorgeous trillion cut Rubilite Tourmalines

2.60 Cts
6 x 6 x 4mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 179, 1, 'loose_stone', 'Tourmaline', 'Rubellite', 2.6, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/e765505a-720a-4723-a019-774086d50ebf/etsy-1.jpg","https://media.gemworkers.com/items/e765505a-720a-4723-a019-774086d50ebf/etsy-2.jpg","https://media.gemworkers.com/items/e765505a-720a-4723-a019-774086d50ebf/etsy-3.jpg","https://media.gemworkers.com/items/e765505a-720a-4723-a019-774086d50ebf/etsy-4.jpg","https://media.gemworkers.com/items/e765505a-720a-4723-a019-774086d50ebf/etsy-5.jpg","https://media.gemworkers.com/items/e765505a-720a-4723-a019-774086d50ebf/etsy-6.jpg","https://media.gemworkers.com/items/e765505a-720a-4723-a019-774086d50ebf/etsy-7.jpg","https://media.gemworkers.com/items/e765505a-720a-4723-a019-774086d50ebf/etsy-8.jpg","https://media.gemworkers.com/items/e765505a-720a-4723-a019-774086d50ebf/etsy-9.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 200 USD, converted at ECB rate. Etsy tags: Red Rubilite,PigeonBlood Rubilite,Orange Rubilite,Pinkish Rubilite,Red Tourmaline,Pink Tourmaline,Orange Tourmaline,Cushion Cut,Tourmaline Jewellery,Tourmaline Faceted,Rubilite Tourmaline,Jewellery Making,Jewellery Findings.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('364bbf94-85e4-4abb-bc9c-1ef01b013a23', '11.80 Cts Rubilite Tourmaline', 'Gorgeous Rubilite Tourmaline Lot

11.80 Cts
8 x 7 x 6.5mm to 10 x 6 x 4mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 197, 1, 'loose_stone', 'Tourmaline', 'Rubellite', 11.8, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/364bbf94-85e4-4abb-bc9c-1ef01b013a23/etsy-1.jpg","https://media.gemworkers.com/items/364bbf94-85e4-4abb-bc9c-1ef01b013a23/etsy-2.jpg","https://media.gemworkers.com/items/364bbf94-85e4-4abb-bc9c-1ef01b013a23/etsy-3.jpg","https://media.gemworkers.com/items/364bbf94-85e4-4abb-bc9c-1ef01b013a23/etsy-4.jpg","https://media.gemworkers.com/items/364bbf94-85e4-4abb-bc9c-1ef01b013a23/etsy-5.jpg","https://media.gemworkers.com/items/364bbf94-85e4-4abb-bc9c-1ef01b013a23/etsy-6.jpg","https://media.gemworkers.com/items/364bbf94-85e4-4abb-bc9c-1ef01b013a23/etsy-7.jpg","https://media.gemworkers.com/items/364bbf94-85e4-4abb-bc9c-1ef01b013a23/etsy-8.jpg","https://media.gemworkers.com/items/364bbf94-85e4-4abb-bc9c-1ef01b013a23/etsy-9.jpg","https://media.gemworkers.com/items/364bbf94-85e4-4abb-bc9c-1ef01b013a23/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 220 USD, converted at ECB rate. Etsy tags: Red Rubilite,PigeonBlood Rubilite,Orange Rubilite,Pinkish Rubilite,Red Tourmaline,Pink Tourmaline,Orange Tourmaline,Cushion Cut,Tourmaline Jewellery,Tourmaline Faceted,Rubilite Tourmaline,Jewellery Making,Jewellery Findings.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('7b4d3b86-ea60-4458-9dc3-5389724ba6c5', '16.30 Cts Rubilite Tourmaline', 'Gorgeous Rubilite Tourmaline Lot

16.30 Cts
6 x 6 x 4mm to 12 x 9 x 5.5mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 357, 1, 'loose_stone', 'Tourmaline', 'Rubellite', 16.3, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/7b4d3b86-ea60-4458-9dc3-5389724ba6c5/etsy-1.jpg","https://media.gemworkers.com/items/7b4d3b86-ea60-4458-9dc3-5389724ba6c5/etsy-2.jpg","https://media.gemworkers.com/items/7b4d3b86-ea60-4458-9dc3-5389724ba6c5/etsy-3.jpg","https://media.gemworkers.com/items/7b4d3b86-ea60-4458-9dc3-5389724ba6c5/etsy-4.jpg","https://media.gemworkers.com/items/7b4d3b86-ea60-4458-9dc3-5389724ba6c5/etsy-5.jpg","https://media.gemworkers.com/items/7b4d3b86-ea60-4458-9dc3-5389724ba6c5/etsy-6.jpg","https://media.gemworkers.com/items/7b4d3b86-ea60-4458-9dc3-5389724ba6c5/etsy-7.jpg","https://media.gemworkers.com/items/7b4d3b86-ea60-4458-9dc3-5389724ba6c5/etsy-8.jpg","https://media.gemworkers.com/items/7b4d3b86-ea60-4458-9dc3-5389724ba6c5/etsy-9.jpg","https://media.gemworkers.com/items/7b4d3b86-ea60-4458-9dc3-5389724ba6c5/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 400 USD, converted at ECB rate. Etsy tags: Red Rubilite,PigeonBlood Rubilite,Orange Rubilite,Pinkish Rubilite,Red Tourmaline,Pink Tourmaline,Orange Tourmaline,Cushion Cut,Tourmaline Jewellery,Tourmaline Faceted,Rubilite Tourmaline,Jewellery Making,Jewellery Findings.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('fdd592fc-6353-4c89-b8f8-4b2d220362e0', '14.70 Cts Rubilite Tourmaline', 'Gorgeous Rubilite Tourmaline Lot

14.70 Cts
7 x 5.5 x 4.5mm to 10 x 7.5 x 6mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 250, 1, 'loose_stone', 'Tourmaline', 'Rubellite', 14.7, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/fdd592fc-6353-4c89-b8f8-4b2d220362e0/etsy-1.jpg","https://media.gemworkers.com/items/fdd592fc-6353-4c89-b8f8-4b2d220362e0/etsy-2.jpg","https://media.gemworkers.com/items/fdd592fc-6353-4c89-b8f8-4b2d220362e0/etsy-3.jpg","https://media.gemworkers.com/items/fdd592fc-6353-4c89-b8f8-4b2d220362e0/etsy-4.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 280 USD, converted at ECB rate. Etsy tags: Red Rubilite,PigeonBlood Rubilite,Orange Rubilite,Pinkish Rubilite,Red Tourmaline,Pink Tourmaline,Orange Tourmaline,Cushion Cut,Tourmaline Jewellery,Tourmaline Faceted,Rubilite Tourmaline,Jewellery Making,Jewellery Findings.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('a69d18a8-4f2e-4c02-a541-17229322fb85', '1.30 Cts Ink Blue Bicolour Tourmaline Pair', 'Top Ink Blue Colour Tourmaline Emerald Cut 

rare find

1.30 Cts
11.4 x 2.2 x 2mm

No Treatment Whatsoever.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 250, 1, 'loose_stone', 'Tourmaline', NULL, 1.3, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/a69d18a8-4f2e-4c02-a541-17229322fb85/etsy-1.jpg","https://media.gemworkers.com/items/a69d18a8-4f2e-4c02-a541-17229322fb85/etsy-2.jpg","https://media.gemworkers.com/items/a69d18a8-4f2e-4c02-a541-17229322fb85/etsy-3.jpg","https://media.gemworkers.com/items/a69d18a8-4f2e-4c02-a541-17229322fb85/etsy-4.jpg","https://media.gemworkers.com/items/a69d18a8-4f2e-4c02-a541-17229322fb85/etsy-5.jpg","https://media.gemworkers.com/items/a69d18a8-4f2e-4c02-a541-17229322fb85/etsy-6.jpg","https://media.gemworkers.com/items/a69d18a8-4f2e-4c02-a541-17229322fb85/etsy-7.jpg","https://media.gemworkers.com/items/a69d18a8-4f2e-4c02-a541-17229322fb85/etsy-8.jpg","https://media.gemworkers.com/items/a69d18a8-4f2e-4c02-a541-17229322fb85/etsy-9.jpg","https://media.gemworkers.com/items/a69d18a8-4f2e-4c02-a541-17229322fb85/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 280 USD, converted at ECB rate. Etsy tags: Emerald Cut,EmeraldCutTourmaline,Jewellery making,earrings stud,Tourmaline Lot,Blue Tourmaline,Lagoon Tourmaline,Neon Blue,neon blue tourmaline,Rings For Men,Tourmalines,Ink Blue Tourmaline,Oceangemsminerals.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('b3524464-b8b1-4113-814d-217931e5871f', '1.85 Cts Ink Blue Bicolour Tourmaline Pair', 'Top Ink Blue Colour Tourmaline Emerald Cut 

rare find

1.85 Cts
13.8 x 2.9 x 2.2mm

No Treatment Whatsoever.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 250, 1, 'loose_stone', 'Tourmaline', NULL, 1.85, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/b3524464-b8b1-4113-814d-217931e5871f/etsy-1.jpg","https://media.gemworkers.com/items/b3524464-b8b1-4113-814d-217931e5871f/etsy-2.jpg","https://media.gemworkers.com/items/b3524464-b8b1-4113-814d-217931e5871f/etsy-3.jpg","https://media.gemworkers.com/items/b3524464-b8b1-4113-814d-217931e5871f/etsy-4.jpg","https://media.gemworkers.com/items/b3524464-b8b1-4113-814d-217931e5871f/etsy-5.jpg","https://media.gemworkers.com/items/b3524464-b8b1-4113-814d-217931e5871f/etsy-6.jpg","https://media.gemworkers.com/items/b3524464-b8b1-4113-814d-217931e5871f/etsy-7.jpg","https://media.gemworkers.com/items/b3524464-b8b1-4113-814d-217931e5871f/etsy-8.jpg","https://media.gemworkers.com/items/b3524464-b8b1-4113-814d-217931e5871f/etsy-9.jpg","https://media.gemworkers.com/items/b3524464-b8b1-4113-814d-217931e5871f/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 280 USD, converted at ECB rate. Etsy tags: Emerald Cut,EmeraldCutTourmaline,Jewellery making,earrings stud,Tourmaline Lot,Blue Tourmaline,Lagoon Tourmaline,Neon Blue,neon blue tourmaline,Rings For Men,Tourmalines,Ink Blue Tourmaline,Oceangemsminerals.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('6a7d9f59-e275-4ade-ab74-9eed08a30d99', '1.85 Cts Ink Blue Bicolour Tourmaline Pair', 'Top Ink Blue Colour Tourmaline Emerald Cut 

rare find

1.85 Cts
13.8 x 2.7 x 2.3mm

No Treatment Whatsoever.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 223, 1, 'loose_stone', 'Tourmaline', NULL, 1.85, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/6a7d9f59-e275-4ade-ab74-9eed08a30d99/etsy-1.jpg","https://media.gemworkers.com/items/6a7d9f59-e275-4ade-ab74-9eed08a30d99/etsy-2.jpg","https://media.gemworkers.com/items/6a7d9f59-e275-4ade-ab74-9eed08a30d99/etsy-3.jpg","https://media.gemworkers.com/items/6a7d9f59-e275-4ade-ab74-9eed08a30d99/etsy-4.jpg","https://media.gemworkers.com/items/6a7d9f59-e275-4ade-ab74-9eed08a30d99/etsy-5.jpg","https://media.gemworkers.com/items/6a7d9f59-e275-4ade-ab74-9eed08a30d99/etsy-6.jpg","https://media.gemworkers.com/items/6a7d9f59-e275-4ade-ab74-9eed08a30d99/etsy-7.jpg","https://media.gemworkers.com/items/6a7d9f59-e275-4ade-ab74-9eed08a30d99/etsy-8.jpg","https://media.gemworkers.com/items/6a7d9f59-e275-4ade-ab74-9eed08a30d99/etsy-9.jpg","https://media.gemworkers.com/items/6a7d9f59-e275-4ade-ab74-9eed08a30d99/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 250 USD, converted at ECB rate. Etsy tags: Emerald Cut,EmeraldCutTourmaline,Jewellery making,earrings stud,Tourmaline Lot,Blue Tourmaline,Lagoon Tourmaline,Neon Blue,neon blue tourmaline,Rings For Men,Tourmalines,Ink Blue Tourmaline,Oceangemsminerals.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('95e79a7a-b2c7-4bb7-9872-ba01e57237da', '4.35 Cts Rare Bicolour Afghan Tourmaline', 'Gorgeous Mesmerising Natural Rare Bicolour Afghan Tourmalines

high lustre, Saturated Colour.

4.35 Cts
8.8 x 7.2 x 4.9mm
6.9 x 5.3 x 4.2mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 268, 1, 'loose_stone', 'Tourmaline', NULL, 4.35, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/95e79a7a-b2c7-4bb7-9872-ba01e57237da/etsy-1.jpg","https://media.gemworkers.com/items/95e79a7a-b2c7-4bb7-9872-ba01e57237da/etsy-2.jpg","https://media.gemworkers.com/items/95e79a7a-b2c7-4bb7-9872-ba01e57237da/etsy-3.jpg","https://media.gemworkers.com/items/95e79a7a-b2c7-4bb7-9872-ba01e57237da/etsy-4.jpg","https://media.gemworkers.com/items/95e79a7a-b2c7-4bb7-9872-ba01e57237da/etsy-5.jpg","https://media.gemworkers.com/items/95e79a7a-b2c7-4bb7-9872-ba01e57237da/etsy-6.jpg","https://media.gemworkers.com/items/95e79a7a-b2c7-4bb7-9872-ba01e57237da/etsy-7.jpg","https://media.gemworkers.com/items/95e79a7a-b2c7-4bb7-9872-ba01e57237da/etsy-8.jpg","https://media.gemworkers.com/items/95e79a7a-b2c7-4bb7-9872-ba01e57237da/etsy-9.jpg","https://media.gemworkers.com/items/95e79a7a-b2c7-4bb7-9872-ba01e57237da/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 300 USD, converted at ECB rate. Etsy tags: Tourmaline Rings,rings for women,rings for men,jewellery making,jewellery findings,gift for her,natural stone,Oceangemsminerals,apple green colour,Bicolour Tourmaline,Natural Bicolour,Unheated Tourmaline,Lipstick Tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('5ec47fa9-8be7-482b-983c-8da2b374aa00', '1.45 Cts Lagoon Colour Tourmaline', 'Presenting One Of The Best Colour In Tourmalines

Exceptional Colour Very Rare To Be Find, Bright Colour Not Dull.

More Beautiful In Real. eye Clean

1.45 Cts
6 x 5.6 x 5.4mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 179, 1, 'loose_stone', 'Tourmaline', NULL, 1.45, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/5ec47fa9-8be7-482b-983c-8da2b374aa00/etsy-1.jpg","https://media.gemworkers.com/items/5ec47fa9-8be7-482b-983c-8da2b374aa00/etsy-2.jpg","https://media.gemworkers.com/items/5ec47fa9-8be7-482b-983c-8da2b374aa00/etsy-3.jpg","https://media.gemworkers.com/items/5ec47fa9-8be7-482b-983c-8da2b374aa00/etsy-4.jpg","https://media.gemworkers.com/items/5ec47fa9-8be7-482b-983c-8da2b374aa00/etsy-5.jpg","https://media.gemworkers.com/items/5ec47fa9-8be7-482b-983c-8da2b374aa00/etsy-6.jpg","https://media.gemworkers.com/items/5ec47fa9-8be7-482b-983c-8da2b374aa00/etsy-7.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 200 USD, converted at ECB rate. Etsy tags: Paraiba Tourmaline,Paraiba Colour,Lagoon Tourmaline,Bluegreen Tourmaline,Blue Tourmaline,Neon Blue Tourmaline,Tourmaline Jewellery,Jewellers,Lagoon Colour,Oceangemsminerals,Ink Blue Tourmaline,Wedding Rings,Rings For Women.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('c6ed27da-32bf-4527-a4e7-5779fa686f5f', '51.90 Cts Mix Colour Tourmaline Cabochon Lot', 'Gorgeous Mix Colour Tourmaline Cabochon Lot

High Lustre And Nice Polished

51.90 Cts
8 to 14mm

unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 241, 1, 'loose_stone', 'Tourmaline', NULL, 51.9, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/c6ed27da-32bf-4527-a4e7-5779fa686f5f/etsy-1.jpg","https://media.gemworkers.com/items/c6ed27da-32bf-4527-a4e7-5779fa686f5f/etsy-2.jpg","https://media.gemworkers.com/items/c6ed27da-32bf-4527-a4e7-5779fa686f5f/etsy-3.jpg","https://media.gemworkers.com/items/c6ed27da-32bf-4527-a4e7-5779fa686f5f/etsy-4.jpg","https://media.gemworkers.com/items/c6ed27da-32bf-4527-a4e7-5779fa686f5f/etsy-5.jpg","https://media.gemworkers.com/items/c6ed27da-32bf-4527-a4e7-5779fa686f5f/etsy-6.jpg","https://media.gemworkers.com/items/c6ed27da-32bf-4527-a4e7-5779fa686f5f/etsy-7.jpg","https://media.gemworkers.com/items/c6ed27da-32bf-4527-a4e7-5779fa686f5f/etsy-8.jpg","https://media.gemworkers.com/items/c6ed27da-32bf-4527-a4e7-5779fa686f5f/etsy-9.jpg","https://media.gemworkers.com/items/c6ed27da-32bf-4527-a4e7-5779fa686f5f/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 270 USD, converted at ECB rate. Etsy tags: Santa Maria Cabochon,Unique Aquamarine,Bicolour Aquamarine,Bicolour Cabochons,Blue Cabochons,Lagoon Cabochons,Natural Stone,jewels,Oceangemsminerals,Tourmaline Rosecuts,Lagoon Rosecuts,Blue Tourmaline,Blue Rosecuts.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('e84785c7-d19a-4aa6-a24a-7ce2b8740f06', '58.40 Cts Mix Colour Tourmaline Cabochon Lot', 'Gorgeous Mix Colour Tourmaline Cabochon Lot

High Lustre And Nice Polished

58.40 Cts
7.8 to 13.8mm

unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 241, 1, 'loose_stone', 'Tourmaline', NULL, 58.4, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/e84785c7-d19a-4aa6-a24a-7ce2b8740f06/etsy-1.jpg","https://media.gemworkers.com/items/e84785c7-d19a-4aa6-a24a-7ce2b8740f06/etsy-2.jpg","https://media.gemworkers.com/items/e84785c7-d19a-4aa6-a24a-7ce2b8740f06/etsy-3.jpg","https://media.gemworkers.com/items/e84785c7-d19a-4aa6-a24a-7ce2b8740f06/etsy-4.jpg","https://media.gemworkers.com/items/e84785c7-d19a-4aa6-a24a-7ce2b8740f06/etsy-5.jpg","https://media.gemworkers.com/items/e84785c7-d19a-4aa6-a24a-7ce2b8740f06/etsy-6.jpg","https://media.gemworkers.com/items/e84785c7-d19a-4aa6-a24a-7ce2b8740f06/etsy-7.jpg","https://media.gemworkers.com/items/e84785c7-d19a-4aa6-a24a-7ce2b8740f06/etsy-8.jpg","https://media.gemworkers.com/items/e84785c7-d19a-4aa6-a24a-7ce2b8740f06/etsy-9.jpg","https://media.gemworkers.com/items/e84785c7-d19a-4aa6-a24a-7ce2b8740f06/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 270 USD, converted at ECB rate. Etsy tags: Santa Maria Cabochon,Unique Aquamarine,Bicolour Aquamarine,Bicolour Cabochons,Blue Cabochons,Lagoon Cabochons,Natural Stone,jewels,Oceangemsminerals,Tourmaline Rosecuts,Lagoon Rosecuts,Blue Tourmaline,Blue Rosecuts.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('125993ab-fbf9-46cf-9759-3066db70315d', '31.25 Cts, Natural Bicolour Afghan Tourmaline', 'Gorgeous Mesmerising Natural Bicolour Afghan Tourmaline

high lustre, Saturated Colour.

31.25 Cts
19.5 x 14.8 x 12.3mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 1340, 1, 'loose_stone', 'Tourmaline', NULL, 31.25, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/125993ab-fbf9-46cf-9759-3066db70315d/etsy-1.jpg","https://media.gemworkers.com/items/125993ab-fbf9-46cf-9759-3066db70315d/etsy-2.jpg","https://media.gemworkers.com/items/125993ab-fbf9-46cf-9759-3066db70315d/etsy-3.jpg","https://media.gemworkers.com/items/125993ab-fbf9-46cf-9759-3066db70315d/etsy-4.jpg","https://media.gemworkers.com/items/125993ab-fbf9-46cf-9759-3066db70315d/etsy-5.jpg","https://media.gemworkers.com/items/125993ab-fbf9-46cf-9759-3066db70315d/etsy-6.jpg","https://media.gemworkers.com/items/125993ab-fbf9-46cf-9759-3066db70315d/etsy-7.jpg","https://media.gemworkers.com/items/125993ab-fbf9-46cf-9759-3066db70315d/etsy-8.jpg","https://media.gemworkers.com/items/125993ab-fbf9-46cf-9759-3066db70315d/etsy-9.jpg","https://media.gemworkers.com/items/125993ab-fbf9-46cf-9759-3066db70315d/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 1500 USD, converted at ECB rate. Etsy tags: Tourmaline Rings,rings for women,rings for men,jewellery making,jewellery findings,gift for her,natural stone,Oceangemsminerals,apple green colour,Bicolour Tourmaline,Natural Bicolour,Unheated Tourmaline,Lipstick Tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('a82417d4-0c3e-428d-b3c0-44708a8b6cf5', '0.7 Cts Lagoon Tourmaline', 'lagoon colour tourmaline

top colour high lustre and brilliance 

Paraiba Like Colour

0.70 cents 
4.9x4.9x4mm

100% natural no treatment whatsoever.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 178, 1, 'loose_stone', 'Tourmaline', NULL, 0.7, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/a82417d4-0c3e-428d-b3c0-44708a8b6cf5/etsy-1.jpg","https://media.gemworkers.com/items/a82417d4-0c3e-428d-b3c0-44708a8b6cf5/etsy-2.jpg","https://media.gemworkers.com/items/a82417d4-0c3e-428d-b3c0-44708a8b6cf5/etsy-3.jpg","https://media.gemworkers.com/items/a82417d4-0c3e-428d-b3c0-44708a8b6cf5/etsy-4.jpg","https://media.gemworkers.com/items/a82417d4-0c3e-428d-b3c0-44708a8b6cf5/etsy-5.jpg","https://media.gemworkers.com/items/a82417d4-0c3e-428d-b3c0-44708a8b6cf5/etsy-6.jpg","https://media.gemworkers.com/items/a82417d4-0c3e-428d-b3c0-44708a8b6cf5/etsy-7.jpg","https://media.gemworkers.com/items/a82417d4-0c3e-428d-b3c0-44708a8b6cf5/etsy-8.jpg","https://media.gemworkers.com/items/a82417d4-0c3e-428d-b3c0-44708a8b6cf5/etsy-9.jpg","https://media.gemworkers.com/items/a82417d4-0c3e-428d-b3c0-44708a8b6cf5/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 199 USD, converted at ECB rate. Etsy tags: Natural Stone,Jewellery Supplies,Jewellery Making,Jewellery Findings,y2k stud earrings,Gift For Her,Rings For Men,Rings For Women,Gold Rings,Silver Sterling,Garnet Necklace,Garnet Rings,Garnet Jewellery.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('aa743ad4-ee55-4ed8-993b-dfe64ebc63d9', '2.15 Cts Lagoon Tourmaline', 'lagoon colour tourmaline

top colour high lustre and brilliance 

Paraiba Like Colour

2.15 Cts
Size:7x7x5.9mm

100% natural no treatment whatsoever.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 357, 1, 'loose_stone', 'Tourmaline', NULL, 2.15, 'ct', NULL, NULL, '7x7x5.9', '["https://media.gemworkers.com/items/aa743ad4-ee55-4ed8-993b-dfe64ebc63d9/etsy-1.jpg","https://media.gemworkers.com/items/aa743ad4-ee55-4ed8-993b-dfe64ebc63d9/etsy-2.jpg","https://media.gemworkers.com/items/aa743ad4-ee55-4ed8-993b-dfe64ebc63d9/etsy-3.jpg","https://media.gemworkers.com/items/aa743ad4-ee55-4ed8-993b-dfe64ebc63d9/etsy-4.jpg","https://media.gemworkers.com/items/aa743ad4-ee55-4ed8-993b-dfe64ebc63d9/etsy-5.jpg","https://media.gemworkers.com/items/aa743ad4-ee55-4ed8-993b-dfe64ebc63d9/etsy-6.jpg","https://media.gemworkers.com/items/aa743ad4-ee55-4ed8-993b-dfe64ebc63d9/etsy-7.jpg","https://media.gemworkers.com/items/aa743ad4-ee55-4ed8-993b-dfe64ebc63d9/etsy-8.jpg","https://media.gemworkers.com/items/aa743ad4-ee55-4ed8-993b-dfe64ebc63d9/etsy-9.jpg","https://media.gemworkers.com/items/aa743ad4-ee55-4ed8-993b-dfe64ebc63d9/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 400 USD, converted at ECB rate. Etsy tags: Natural Stone,Jewellery Supplies,Jewellery Making,Jewellery Findings,y2k stud earrings,Gift For Her,Rings For Men,Rings For Women,Gold Rings,Silver Sterling,Garnet Necklace,Garnet Rings,Garnet Jewellery.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('b9a9704e-8a75-4852-8220-e73bf67af796', '8.7 Cts Tourmaline Lot', 'Beautiful Tourmaline Lot 

 Seafoam,Green colours 

8.70 Cts
6 to 11.5 mm

no treatment whatsoever', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 179, 1, 'loose_stone', 'Tourmaline', NULL, 8.7, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/b9a9704e-8a75-4852-8220-e73bf67af796/etsy-1.jpg","https://media.gemworkers.com/items/b9a9704e-8a75-4852-8220-e73bf67af796/etsy-2.jpg","https://media.gemworkers.com/items/b9a9704e-8a75-4852-8220-e73bf67af796/etsy-3.jpg","https://media.gemworkers.com/items/b9a9704e-8a75-4852-8220-e73bf67af796/etsy-4.jpg","https://media.gemworkers.com/items/b9a9704e-8a75-4852-8220-e73bf67af796/etsy-5.jpg","https://media.gemworkers.com/items/b9a9704e-8a75-4852-8220-e73bf67af796/etsy-6.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 200 USD, converted at ECB rate. Etsy tags: Jewellery Making,Jewellery Supplies,Jewellery Findings,Tourmaline Lot,Seafoam Tourmaline,Green Tourmaline,Tourmaline Jewellery,Gift For Her,Natural Stone,Pink Tourmaline,Stud Earrings,Hoop earrings,handmade.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('40b2363f-ea75-4480-b0e3-dd14f285dfb6', '4.20 Cts Bicolour Tourmaline', 'Bicolour Tourmalines at very reasonable price 

4.20 Cts
8 to 12mm', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 71, 1, 'loose_stone', 'Tourmaline', NULL, 4.2, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/40b2363f-ea75-4480-b0e3-dd14f285dfb6/etsy-1.jpg","https://media.gemworkers.com/items/40b2363f-ea75-4480-b0e3-dd14f285dfb6/etsy-2.jpg","https://media.gemworkers.com/items/40b2363f-ea75-4480-b0e3-dd14f285dfb6/etsy-3.jpg","https://media.gemworkers.com/items/40b2363f-ea75-4480-b0e3-dd14f285dfb6/etsy-4.jpg","https://media.gemworkers.com/items/40b2363f-ea75-4480-b0e3-dd14f285dfb6/etsy-5.jpg","https://media.gemworkers.com/items/40b2363f-ea75-4480-b0e3-dd14f285dfb6/etsy-6.jpg","https://media.gemworkers.com/items/40b2363f-ea75-4480-b0e3-dd14f285dfb6/etsy-7.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 80 USD, converted at ECB rate. Etsy tags: Jewellery Making,Jewellery Supplies,Jewellery Findings,Tourmaline Lot,Bicolour Tourmaline,Pink Tourmaline,Natural Stone,y2k earrings stud,Tourmaline Jewellery,Tourmaline Findings,Tourmaline Supplies,Jewellery Stud,Gift For Her.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('18325532-9d10-4595-9d86-5b1650271bae', 'Kunzite Crystal 16 Grams', 'Ethically Sourced Kunzite Crystal 

Faceted Grade, Loupe Clean Inside

16 Gram
64 x 11.5 x 8mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 179, 1, 'specimen', 'Kunzite', NULL, NULL, NULL, NULL, NULL, NULL, '["https://media.gemworkers.com/items/18325532-9d10-4595-9d86-5b1650271bae/etsy-1.jpg","https://media.gemworkers.com/items/18325532-9d10-4595-9d86-5b1650271bae/etsy-2.jpg","https://media.gemworkers.com/items/18325532-9d10-4595-9d86-5b1650271bae/etsy-3.jpg","https://media.gemworkers.com/items/18325532-9d10-4595-9d86-5b1650271bae/etsy-4.jpg","https://media.gemworkers.com/items/18325532-9d10-4595-9d86-5b1650271bae/etsy-5.jpg","https://media.gemworkers.com/items/18325532-9d10-4595-9d86-5b1650271bae/etsy-6.jpg","https://media.gemworkers.com/items/18325532-9d10-4595-9d86-5b1650271bae/etsy-7.jpg","https://media.gemworkers.com/items/18325532-9d10-4595-9d86-5b1650271bae/etsy-8.jpg","https://media.gemworkers.com/items/18325532-9d10-4595-9d86-5b1650271bae/etsy-9.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 200 USD, converted at ECB rate. Etsy tags: Terminated Crystals,Jewellery Making,Aquamarine Specimen,Collectors,AquamarineCollection,Blue Aquamarine,Green Aquamarine,Gift For Her,Natural Stone,Kunzite Crystal,Heated Kunzite,Rough Kunzite,Kunzite Jewellery.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('4ed549e3-87de-4b12-a5ae-5ffdb1c3e4c6', '15.25 Cts Tourmaline Pairs', 'A Very High Lustre Unique Colour Tourmaline Pairs

High Quality Fine Cut

15.25 Cts
7.1 to 8mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 884, 1, 'loose_stone', 'Tourmaline', NULL, 15.25, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/4ed549e3-87de-4b12-a5ae-5ffdb1c3e4c6/etsy-1.jpg","https://media.gemworkers.com/items/4ed549e3-87de-4b12-a5ae-5ffdb1c3e4c6/etsy-2.jpg","https://media.gemworkers.com/items/4ed549e3-87de-4b12-a5ae-5ffdb1c3e4c6/etsy-3.jpg","https://media.gemworkers.com/items/4ed549e3-87de-4b12-a5ae-5ffdb1c3e4c6/etsy-4.jpg","https://media.gemworkers.com/items/4ed549e3-87de-4b12-a5ae-5ffdb1c3e4c6/etsy-5.jpg","https://media.gemworkers.com/items/4ed549e3-87de-4b12-a5ae-5ffdb1c3e4c6/etsy-6.jpg","https://media.gemworkers.com/items/4ed549e3-87de-4b12-a5ae-5ffdb1c3e4c6/etsy-7.jpg","https://media.gemworkers.com/items/4ed549e3-87de-4b12-a5ae-5ffdb1c3e4c6/etsy-8.jpg","https://media.gemworkers.com/items/4ed549e3-87de-4b12-a5ae-5ffdb1c3e4c6/etsy-9.jpg","https://media.gemworkers.com/items/4ed549e3-87de-4b12-a5ae-5ffdb1c3e4c6/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 990 USD, converted at ECB rate. Etsy tags: Tourmaline Earrings,Earrings Set,Fine Tourmaline,Canary Tourmaline,Lagoon Tourmaline,Blue Tourmaline,Yellow Tourmaline,Stud Earrings,Tourmaline Jewellery,Jewellery Set,Oceangemsminerals,Tourmaline Pairs,Lagoon Pairs.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('17b3fbcc-fa8d-4b5d-b71f-91e0d752c266', '1.65 Cts Bicolour Tourmaline', 'Natural Afghanistan Bicolour Tourmaline

Very Unique And One Of A Kind

1.65 Cts
13 x 3.5 x 2.9mm

unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 178, 1, 'loose_stone', 'Tourmaline', NULL, 1.65, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/17b3fbcc-fa8d-4b5d-b71f-91e0d752c266/etsy-1.jpg","https://media.gemworkers.com/items/17b3fbcc-fa8d-4b5d-b71f-91e0d752c266/etsy-2.jpg","https://media.gemworkers.com/items/17b3fbcc-fa8d-4b5d-b71f-91e0d752c266/etsy-3.jpg","https://media.gemworkers.com/items/17b3fbcc-fa8d-4b5d-b71f-91e0d752c266/etsy-4.jpg","https://media.gemworkers.com/items/17b3fbcc-fa8d-4b5d-b71f-91e0d752c266/etsy-5.jpg","https://media.gemworkers.com/items/17b3fbcc-fa8d-4b5d-b71f-91e0d752c266/etsy-6.jpg","https://media.gemworkers.com/items/17b3fbcc-fa8d-4b5d-b71f-91e0d752c266/etsy-7.jpg","https://media.gemworkers.com/items/17b3fbcc-fa8d-4b5d-b71f-91e0d752c266/etsy-8.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 199 USD, converted at ECB rate. Etsy tags: Gold Rings,Rings For Men,Gift For Her,Tourmaline Jewellery,Natural Stone,Stud Earrings,Jewellery Stud,bicolour Tourmaline,Lagoon tourmaline,Tricolour Tourmaline,Oceangemsminerals,blue tourmaline,tourmaline pairs.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('5f37617c-8125-4c82-bf37-713cbf891b87', '2 Cts Lagoon Bicolour Tourmaline', 'Gorgeous Mesmerising Bicolour Lagoon Natural Afghanistan Tourmaline 

More beautiful In real, One of a kind

2 Cts
7.3 x 6.2 x 4.4mm

unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 267, 1, 'loose_stone', 'Tourmaline', NULL, 2, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/5f37617c-8125-4c82-bf37-713cbf891b87/etsy-1.jpg","https://media.gemworkers.com/items/5f37617c-8125-4c82-bf37-713cbf891b87/etsy-2.jpg","https://media.gemworkers.com/items/5f37617c-8125-4c82-bf37-713cbf891b87/etsy-3.jpg","https://media.gemworkers.com/items/5f37617c-8125-4c82-bf37-713cbf891b87/etsy-4.jpg","https://media.gemworkers.com/items/5f37617c-8125-4c82-bf37-713cbf891b87/etsy-5.jpg","https://media.gemworkers.com/items/5f37617c-8125-4c82-bf37-713cbf891b87/etsy-6.jpg","https://media.gemworkers.com/items/5f37617c-8125-4c82-bf37-713cbf891b87/etsy-7.jpg","https://media.gemworkers.com/items/5f37617c-8125-4c82-bf37-713cbf891b87/etsy-8.jpg","https://media.gemworkers.com/items/5f37617c-8125-4c82-bf37-713cbf891b87/etsy-9.jpg","https://media.gemworkers.com/items/5f37617c-8125-4c82-bf37-713cbf891b87/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 299 USD, converted at ECB rate. Etsy tags: Gold Rings,Rings For Men,Tourmaline Jewellery,Natural Stone,bicolour Tourmaline,Lagoon tourmaline,Bluegreen tourmaline,blue tourmaline,indicolite tourmalin,tourmaline rings,faceted tourmaline,Oceangemsminerals,tourmaline lot.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('9da81716-bacf-426c-8394-ab2117e96ee3', '2.80 Cts Neon Blue Tourmaline', 'lagoon and neon blue colour tourmaline

top colour high lustre and brilliance 

Ethopian Paraiba Like Colour

2.80 Cts
8 x 6.7 x 5.7mm

100% natural no treatment whatsoever.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 982, 1, 'loose_stone', 'Tourmaline', NULL, 2.8, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/9da81716-bacf-426c-8394-ab2117e96ee3/etsy-1.jpg","https://media.gemworkers.com/items/9da81716-bacf-426c-8394-ab2117e96ee3/etsy-2.jpg","https://media.gemworkers.com/items/9da81716-bacf-426c-8394-ab2117e96ee3/etsy-3.jpg","https://media.gemworkers.com/items/9da81716-bacf-426c-8394-ab2117e96ee3/etsy-4.jpg","https://media.gemworkers.com/items/9da81716-bacf-426c-8394-ab2117e96ee3/etsy-5.jpg","https://media.gemworkers.com/items/9da81716-bacf-426c-8394-ab2117e96ee3/etsy-6.jpg","https://media.gemworkers.com/items/9da81716-bacf-426c-8394-ab2117e96ee3/etsy-7.jpg","https://media.gemworkers.com/items/9da81716-bacf-426c-8394-ab2117e96ee3/etsy-8.jpg","https://media.gemworkers.com/items/9da81716-bacf-426c-8394-ab2117e96ee3/etsy-9.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 1099 USD, converted at ECB rate. Etsy tags: Natural Stone,Jewellery Supplies,Jewellery Making,Jewellery Findings,y2k stud earrings,Gift For Her,Rings For Men,Rings For Women,Gold Rings,Silver Sterling,Garnet Necklace,Garnet Rings,Garnet Jewellery.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('d57ce16a-ec6d-463d-9acf-d5ddc55b8d1c', '2.10 Cts Neon Blue Tourmaline', 'lagoon and neon blue colour tourmaline

top colour high lustre and brilliance 

Ethopian Paraiba Like Colour

2.10 Cts
7 x 5.6 x 5.5mm

100% natural no treatment whatsoever.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 893, 1, 'loose_stone', 'Tourmaline', NULL, 2.1, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/d57ce16a-ec6d-463d-9acf-d5ddc55b8d1c/etsy-1.jpg","https://media.gemworkers.com/items/d57ce16a-ec6d-463d-9acf-d5ddc55b8d1c/etsy-2.jpg","https://media.gemworkers.com/items/d57ce16a-ec6d-463d-9acf-d5ddc55b8d1c/etsy-3.jpg","https://media.gemworkers.com/items/d57ce16a-ec6d-463d-9acf-d5ddc55b8d1c/etsy-4.jpg","https://media.gemworkers.com/items/d57ce16a-ec6d-463d-9acf-d5ddc55b8d1c/etsy-5.jpg","https://media.gemworkers.com/items/d57ce16a-ec6d-463d-9acf-d5ddc55b8d1c/etsy-6.jpg","https://media.gemworkers.com/items/d57ce16a-ec6d-463d-9acf-d5ddc55b8d1c/etsy-7.jpg","https://media.gemworkers.com/items/d57ce16a-ec6d-463d-9acf-d5ddc55b8d1c/etsy-8.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 999 USD, converted at ECB rate. Etsy tags: Natural Stone,Jewellery Supplies,Jewellery Making,Jewellery Findings,y2k stud earrings,Gift For Her,Rings For Men,Rings For Women,Gold Rings,Silver Sterling,Garnet Necklace,Garnet Rings,Garnet Jewellery.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('3d0d21fc-3b5d-4046-a7f4-e9d7234ad1fd', '1 Cts Neon Blue Tourmaline', 'lagoon and neon blue colour tourmaline

top colour high lustre and brilliance 

Paraiba Like Colour

1 Cts
5.6 x 5.4 x 4.4mm

100% natural no treatment whatsoever.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 357, 1, 'loose_stone', 'Tourmaline', NULL, 1, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/3d0d21fc-3b5d-4046-a7f4-e9d7234ad1fd/etsy-1.jpg","https://media.gemworkers.com/items/3d0d21fc-3b5d-4046-a7f4-e9d7234ad1fd/etsy-2.jpg","https://media.gemworkers.com/items/3d0d21fc-3b5d-4046-a7f4-e9d7234ad1fd/etsy-3.jpg","https://media.gemworkers.com/items/3d0d21fc-3b5d-4046-a7f4-e9d7234ad1fd/etsy-4.jpg","https://media.gemworkers.com/items/3d0d21fc-3b5d-4046-a7f4-e9d7234ad1fd/etsy-5.jpg","https://media.gemworkers.com/items/3d0d21fc-3b5d-4046-a7f4-e9d7234ad1fd/etsy-6.jpg","https://media.gemworkers.com/items/3d0d21fc-3b5d-4046-a7f4-e9d7234ad1fd/etsy-7.jpg","https://media.gemworkers.com/items/3d0d21fc-3b5d-4046-a7f4-e9d7234ad1fd/etsy-8.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 400 USD, converted at ECB rate. Etsy tags: Natural Stone,Jewellery Supplies,Jewellery Making,Jewellery Findings,y2k stud earrings,Gift For Her,Rings For Men,Rings For Women,Gold Rings,Silver Sterling,Garnet Necklace,Garnet Rings,Garnet Jewellery.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('5641efe2-c0cc-4753-91de-428687865c14', '1 Cts Neon Blue Tourmaline', 'lagoon and neon blue colour tourmaline

top colour high lustre and brilliance 

Ethopian Paraiba Like Colour

1 Cts
5.6 x 5.4 x 4.4mm

100% natural no treatment whatsoever.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 357, 1, 'loose_stone', 'Tourmaline', NULL, 1, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/5641efe2-c0cc-4753-91de-428687865c14/etsy-1.jpg","https://media.gemworkers.com/items/5641efe2-c0cc-4753-91de-428687865c14/etsy-2.jpg","https://media.gemworkers.com/items/5641efe2-c0cc-4753-91de-428687865c14/etsy-3.jpg","https://media.gemworkers.com/items/5641efe2-c0cc-4753-91de-428687865c14/etsy-4.jpg","https://media.gemworkers.com/items/5641efe2-c0cc-4753-91de-428687865c14/etsy-5.jpg","https://media.gemworkers.com/items/5641efe2-c0cc-4753-91de-428687865c14/etsy-6.jpg","https://media.gemworkers.com/items/5641efe2-c0cc-4753-91de-428687865c14/etsy-7.jpg","https://media.gemworkers.com/items/5641efe2-c0cc-4753-91de-428687865c14/etsy-8.jpg","https://media.gemworkers.com/items/5641efe2-c0cc-4753-91de-428687865c14/etsy-9.jpg","https://media.gemworkers.com/items/5641efe2-c0cc-4753-91de-428687865c14/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 400 USD, converted at ECB rate. Etsy tags: Natural Stone,Jewellery Supplies,Jewellery Making,Jewellery Findings,y2k stud earrings,Gift For Her,Rings For Men,Rings For Women,Gold Rings,Silver Sterling,Garnet Necklace,Garnet Rings,Garnet Jewellery.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('e322e6c3-6f83-4679-b2f2-b4eeae820777', '1.80 Cts Blue Green Tourmaline', 'Gorgeous Mesmerising Blue Green Afghan Tourmaline 

Unique Colour 

1.80 Cts
7.2 x 5.6 x 4.6mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 313, 1, 'loose_stone', 'Tourmaline', NULL, 1.8, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/e322e6c3-6f83-4679-b2f2-b4eeae820777/etsy-1.jpg","https://media.gemworkers.com/items/e322e6c3-6f83-4679-b2f2-b4eeae820777/etsy-2.jpg","https://media.gemworkers.com/items/e322e6c3-6f83-4679-b2f2-b4eeae820777/etsy-3.jpg","https://media.gemworkers.com/items/e322e6c3-6f83-4679-b2f2-b4eeae820777/etsy-4.jpg","https://media.gemworkers.com/items/e322e6c3-6f83-4679-b2f2-b4eeae820777/etsy-5.jpg","https://media.gemworkers.com/items/e322e6c3-6f83-4679-b2f2-b4eeae820777/etsy-6.jpg","https://media.gemworkers.com/items/e322e6c3-6f83-4679-b2f2-b4eeae820777/etsy-7.jpg","https://media.gemworkers.com/items/e322e6c3-6f83-4679-b2f2-b4eeae820777/etsy-8.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 350 USD, converted at ECB rate. Etsy tags: BlueGreen Tourmaline,Blue Tourmaline,Green Tourmaline,Lagoon Tourmaline,Neon Tourmaline,Tourmaline Rings,rings for women,rings for men,jewellery making,jewellery supplies,jewellery findings,gift for her,natural stone.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('62a22cfc-dd71-437c-8c75-2eaaf39df3da', '1.20 Cts Baby Pink Tourmaline', 'mesmerising baby pink tourmaline 

Top Quality Fineest Colour

1.20 Cts
6.8 x 5 x 3.8mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 179, 1, 'loose_stone', 'Tourmaline', NULL, 1.2, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/62a22cfc-dd71-437c-8c75-2eaaf39df3da/etsy-1.jpg","https://media.gemworkers.com/items/62a22cfc-dd71-437c-8c75-2eaaf39df3da/etsy-2.jpg","https://media.gemworkers.com/items/62a22cfc-dd71-437c-8c75-2eaaf39df3da/etsy-3.jpg","https://media.gemworkers.com/items/62a22cfc-dd71-437c-8c75-2eaaf39df3da/etsy-4.jpg","https://media.gemworkers.com/items/62a22cfc-dd71-437c-8c75-2eaaf39df3da/etsy-5.jpg","https://media.gemworkers.com/items/62a22cfc-dd71-437c-8c75-2eaaf39df3da/etsy-6.jpg","https://media.gemworkers.com/items/62a22cfc-dd71-437c-8c75-2eaaf39df3da/etsy-7.jpg","https://media.gemworkers.com/items/62a22cfc-dd71-437c-8c75-2eaaf39df3da/etsy-8.jpg","https://media.gemworkers.com/items/62a22cfc-dd71-437c-8c75-2eaaf39df3da/etsy-9.jpg","https://media.gemworkers.com/items/62a22cfc-dd71-437c-8c75-2eaaf39df3da/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 200 USD, converted at ECB rate. Etsy tags: Emerald Cut,Bicolour Tourmaline,Tricolour Tourmaline,Pink Bicolour,Unheated,Tourmaline jewellery,Natural Stone,Gift For Her,Blue tourmalines,Green Tourmaline,Rings For Men,Gold Rings,Stud Jewellery.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('bcd0aa37-1b67-426d-9607-bce63d37a4e7', '6.50 Cts Special Bicolour Tourmaline', 'Sweet Perfect Bicolour Tourmaline 

Unique And Rare Colour

Very Shiny And High Lustre 

6.50 Cts
10.5 x 9.9 x 7.5mm

No treatment.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 446, 1, 'loose_stone', 'Tourmaline', NULL, 6.5, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/bcd0aa37-1b67-426d-9607-bce63d37a4e7/etsy-1.jpg","https://media.gemworkers.com/items/bcd0aa37-1b67-426d-9607-bce63d37a4e7/etsy-2.jpg","https://media.gemworkers.com/items/bcd0aa37-1b67-426d-9607-bce63d37a4e7/etsy-3.jpg","https://media.gemworkers.com/items/bcd0aa37-1b67-426d-9607-bce63d37a4e7/etsy-4.jpg","https://media.gemworkers.com/items/bcd0aa37-1b67-426d-9607-bce63d37a4e7/etsy-5.jpg","https://media.gemworkers.com/items/bcd0aa37-1b67-426d-9607-bce63d37a4e7/etsy-6.jpg","https://media.gemworkers.com/items/bcd0aa37-1b67-426d-9607-bce63d37a4e7/etsy-7.jpg","https://media.gemworkers.com/items/bcd0aa37-1b67-426d-9607-bce63d37a4e7/etsy-8.jpg","https://media.gemworkers.com/items/bcd0aa37-1b67-426d-9607-bce63d37a4e7/etsy-9.jpg","https://media.gemworkers.com/items/bcd0aa37-1b67-426d-9607-bce63d37a4e7/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 499 USD, converted at ECB rate. Etsy tags: Tourmaline Jewellery,Tourmaline Earrings,Earrings Stud,y2k earrings stud,Gold Rings,Natural Stone,Gift For Her,Rings For Men,Oceangemsminerals,lagoon tourmaline,tourmaline pairs,bicolour tourmaline,Watermelon Bicolour.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('326ab76e-2313-4417-a21e-49d5133dc319', '11.80 Cts Bicolour Tourmaline Lot', 'Natural Afghanistan Bicolour Tourmaline Lot

Very Unique And One Of A Kind

11.80 Cts
13.8 to 9.2mm

unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 357, 1, 'loose_stone', 'Tourmaline', NULL, 11.8, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/326ab76e-2313-4417-a21e-49d5133dc319/etsy-1.jpg","https://media.gemworkers.com/items/326ab76e-2313-4417-a21e-49d5133dc319/etsy-2.jpg","https://media.gemworkers.com/items/326ab76e-2313-4417-a21e-49d5133dc319/etsy-3.jpg","https://media.gemworkers.com/items/326ab76e-2313-4417-a21e-49d5133dc319/etsy-4.jpg","https://media.gemworkers.com/items/326ab76e-2313-4417-a21e-49d5133dc319/etsy-5.jpg","https://media.gemworkers.com/items/326ab76e-2313-4417-a21e-49d5133dc319/etsy-6.jpg","https://media.gemworkers.com/items/326ab76e-2313-4417-a21e-49d5133dc319/etsy-7.jpg","https://media.gemworkers.com/items/326ab76e-2313-4417-a21e-49d5133dc319/etsy-8.jpg","https://media.gemworkers.com/items/326ab76e-2313-4417-a21e-49d5133dc319/etsy-9.jpg","https://media.gemworkers.com/items/326ab76e-2313-4417-a21e-49d5133dc319/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 400 USD, converted at ECB rate. Etsy tags: Gold Rings,Rings For Men,Gift For Her,Tourmaline Jewellery,Natural Stone,Stud Earrings,Jewellery Stud,bicolour Tourmaline,Lagoon tourmaline,Tricolour Tourmaline,Oceangemsminerals,blue tourmaline,tourmaline pairs.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('9c83b1e7-0e26-4ff4-acbf-d86a3dc891e8', '2.20 Cts Special Bicolour Tourmaline', 'Sweet Perfect Bicolour Tourmaline 

Unique And Rare Colour

Very Shiny And High Lustre 

2.20 Cts
8 x 6.6 x 4.4mm

No treatment.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 267, 1, 'loose_stone', 'Tourmaline', NULL, 2.2, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/9c83b1e7-0e26-4ff4-acbf-d86a3dc891e8/etsy-1.jpg","https://media.gemworkers.com/items/9c83b1e7-0e26-4ff4-acbf-d86a3dc891e8/etsy-2.jpg","https://media.gemworkers.com/items/9c83b1e7-0e26-4ff4-acbf-d86a3dc891e8/etsy-3.jpg","https://media.gemworkers.com/items/9c83b1e7-0e26-4ff4-acbf-d86a3dc891e8/etsy-4.jpg","https://media.gemworkers.com/items/9c83b1e7-0e26-4ff4-acbf-d86a3dc891e8/etsy-5.jpg","https://media.gemworkers.com/items/9c83b1e7-0e26-4ff4-acbf-d86a3dc891e8/etsy-6.jpg","https://media.gemworkers.com/items/9c83b1e7-0e26-4ff4-acbf-d86a3dc891e8/etsy-7.jpg","https://media.gemworkers.com/items/9c83b1e7-0e26-4ff4-acbf-d86a3dc891e8/etsy-8.jpg","https://media.gemworkers.com/items/9c83b1e7-0e26-4ff4-acbf-d86a3dc891e8/etsy-9.jpg","https://media.gemworkers.com/items/9c83b1e7-0e26-4ff4-acbf-d86a3dc891e8/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 299 USD, converted at ECB rate. Etsy tags: Tourmaline Jewellery,Tourmaline Earrings,Earrings Stud,y2k earrings stud,Gold Rings,Natural Stone,Gift For Her,Rings For Men,Oceangemsminerals,lagoon tourmaline,tourmaline pairs,bicolour tourmaline,Watermelon Bicolour.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('be1c220a-72fa-4c08-a89a-cfc05f66a034', '1.80 Cts Special Bicolour Tourmaline', 'Sweet Perfect Bicolour Tourmaline 

Unique And Rare Colour

Very Shiny And High Lustre 

1.80 Cts
7 x 5.7 x 4.8mm

No treatment.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 267, 1, 'loose_stone', 'Tourmaline', NULL, 1.8, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/be1c220a-72fa-4c08-a89a-cfc05f66a034/etsy-1.jpg","https://media.gemworkers.com/items/be1c220a-72fa-4c08-a89a-cfc05f66a034/etsy-2.jpg","https://media.gemworkers.com/items/be1c220a-72fa-4c08-a89a-cfc05f66a034/etsy-3.jpg","https://media.gemworkers.com/items/be1c220a-72fa-4c08-a89a-cfc05f66a034/etsy-4.jpg","https://media.gemworkers.com/items/be1c220a-72fa-4c08-a89a-cfc05f66a034/etsy-5.jpg","https://media.gemworkers.com/items/be1c220a-72fa-4c08-a89a-cfc05f66a034/etsy-6.jpg","https://media.gemworkers.com/items/be1c220a-72fa-4c08-a89a-cfc05f66a034/etsy-7.jpg","https://media.gemworkers.com/items/be1c220a-72fa-4c08-a89a-cfc05f66a034/etsy-8.jpg","https://media.gemworkers.com/items/be1c220a-72fa-4c08-a89a-cfc05f66a034/etsy-9.jpg","https://media.gemworkers.com/items/be1c220a-72fa-4c08-a89a-cfc05f66a034/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 299 USD, converted at ECB rate. Etsy tags: Tourmaline Jewellery,Tourmaline Earrings,Earrings Stud,y2k earrings stud,Gold Rings,Natural Stone,Gift For Her,Rings For Men,Oceangemsminerals,lagoon tourmaline,tourmaline pairs,bicolour tourmaline,Watermelon Bicolour.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('d5110995-45df-4f84-af1a-356d9698f227', '8 Cts Dark Green Tourmaline', 'Gorgeous Mesmerising Dark Green Cool Colour Afghan Tourmaline 

better looking in real

8 Cts
14.2 x 9.2 x 6.4mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 179, 1, 'loose_stone', 'Tourmaline', NULL, 8, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/d5110995-45df-4f84-af1a-356d9698f227/etsy-1.jpg","https://media.gemworkers.com/items/d5110995-45df-4f84-af1a-356d9698f227/etsy-2.jpg","https://media.gemworkers.com/items/d5110995-45df-4f84-af1a-356d9698f227/etsy-3.jpg","https://media.gemworkers.com/items/d5110995-45df-4f84-af1a-356d9698f227/etsy-4.jpg","https://media.gemworkers.com/items/d5110995-45df-4f84-af1a-356d9698f227/etsy-5.jpg","https://media.gemworkers.com/items/d5110995-45df-4f84-af1a-356d9698f227/etsy-6.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 200 USD, converted at ECB rate. Etsy tags: Tourmaline Jewellery,Jewellery Supplies,Jewellery Making,Jewellery Findings,Tourmaline Earrings,Earrings Stud,y2k earrings stud,Gold Rings,Natural Stone,Gift For Her,Rings For Men,Rings For Women,Chrome Tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('25e4b22e-59aa-4201-be43-66e5538ff10c', '4.2 Cts indicolite Tourmaline', 'indicolite Tourmaline Emerald Cut 

rare find

4.20 Cts
17 x 5.5 x 4.2mm

No Treatment Whatsoever.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 356, 1, 'loose_stone', 'Tourmaline', 'Indicolite', 4.2, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/25e4b22e-59aa-4201-be43-66e5538ff10c/etsy-1.jpg","https://media.gemworkers.com/items/25e4b22e-59aa-4201-be43-66e5538ff10c/etsy-2.jpg","https://media.gemworkers.com/items/25e4b22e-59aa-4201-be43-66e5538ff10c/etsy-3.jpg","https://media.gemworkers.com/items/25e4b22e-59aa-4201-be43-66e5538ff10c/etsy-4.jpg","https://media.gemworkers.com/items/25e4b22e-59aa-4201-be43-66e5538ff10c/etsy-5.jpg","https://media.gemworkers.com/items/25e4b22e-59aa-4201-be43-66e5538ff10c/etsy-6.jpg","https://media.gemworkers.com/items/25e4b22e-59aa-4201-be43-66e5538ff10c/etsy-7.jpg","https://media.gemworkers.com/items/25e4b22e-59aa-4201-be43-66e5538ff10c/etsy-8.jpg","https://media.gemworkers.com/items/25e4b22e-59aa-4201-be43-66e5538ff10c/etsy-9.jpg","https://media.gemworkers.com/items/25e4b22e-59aa-4201-be43-66e5538ff10c/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 399 USD, converted at ECB rate. Etsy tags: Emerald Cut,EmeraldCutTourmaline,Jewellery making,earrings stud,Tourmaline Lot,Blue Tourmaline,Lagoon Tourmaline,Neon Blue,neon blue tourmaline,Rings For Men,Tourmalines,Ink Blue Tourmaline,Oceangemsminerals.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('6fc7fa35-34ef-4461-98da-2ca4c2b695b8', '8.45 Cts, Unique Pink Colour Afghan Tourmaline Lot.', 'Mesmerising Unique And Rare Colour Tourmaline Lot.

Cute Looking, , high lustre

8.45 carats   
7.6x5.8x4.1mm
10.8x8.4x6.4mm 
11.3x5.7x3.4mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 179, 1, 'loose_stone', 'Tourmaline', NULL, 8.45, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/6fc7fa35-34ef-4461-98da-2ca4c2b695b8/etsy-1.jpg","https://media.gemworkers.com/items/6fc7fa35-34ef-4461-98da-2ca4c2b695b8/etsy-2.jpg","https://media.gemworkers.com/items/6fc7fa35-34ef-4461-98da-2ca4c2b695b8/etsy-3.jpg","https://media.gemworkers.com/items/6fc7fa35-34ef-4461-98da-2ca4c2b695b8/etsy-4.jpg","https://media.gemworkers.com/items/6fc7fa35-34ef-4461-98da-2ca4c2b695b8/etsy-5.jpg","https://media.gemworkers.com/items/6fc7fa35-34ef-4461-98da-2ca4c2b695b8/etsy-6.jpg","https://media.gemworkers.com/items/6fc7fa35-34ef-4461-98da-2ca4c2b695b8/etsy-7.jpg","https://media.gemworkers.com/items/6fc7fa35-34ef-4461-98da-2ca4c2b695b8/etsy-8.jpg","https://media.gemworkers.com/items/6fc7fa35-34ef-4461-98da-2ca4c2b695b8/etsy-9.jpg","https://media.gemworkers.com/items/6fc7fa35-34ef-4461-98da-2ca4c2b695b8/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 200 USD, converted at ECB rate. Etsy tags: Rings For Men,Rings For Women,Jewellery Stud,Tourmaline Rings,Gift For Her,Gold rings,Natural Stone,Jewels,Handmade,Oceangemsminerals,Unique Tourmaline,Rare Tourmaline,Pink Tourmaline Lot.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('befec3b6-8c22-4226-a24d-db9dcff015ac', '3.95 Cts Bicolour Tourmaline', 'Natural bicolour mesmerising tourmaline 

3.95 carats   
Size:17.9x5.3x4.1mm

unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 134, 1, 'loose_stone', 'Tourmaline', NULL, 3.95, 'ct', NULL, NULL, '17.9x5.3x4.1', '["https://media.gemworkers.com/items/befec3b6-8c22-4226-a24d-db9dcff015ac/etsy-1.jpg","https://media.gemworkers.com/items/befec3b6-8c22-4226-a24d-db9dcff015ac/etsy-2.jpg","https://media.gemworkers.com/items/befec3b6-8c22-4226-a24d-db9dcff015ac/etsy-3.jpg","https://media.gemworkers.com/items/befec3b6-8c22-4226-a24d-db9dcff015ac/etsy-4.jpg","https://media.gemworkers.com/items/befec3b6-8c22-4226-a24d-db9dcff015ac/etsy-5.jpg","https://media.gemworkers.com/items/befec3b6-8c22-4226-a24d-db9dcff015ac/etsy-6.jpg","https://media.gemworkers.com/items/befec3b6-8c22-4226-a24d-db9dcff015ac/etsy-7.jpg","https://media.gemworkers.com/items/befec3b6-8c22-4226-a24d-db9dcff015ac/etsy-8.jpg","https://media.gemworkers.com/items/befec3b6-8c22-4226-a24d-db9dcff015ac/etsy-9.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 150 USD, converted at ECB rate. Etsy tags: Rings for women,rings for men,natural stone,gift for her,jewellery making,jewellery supplies,jewellery findings,bicolour tourmaline,pink tourmaline,stud jewellery,emerald cut,green tourmaline,Pink Bicolour.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('77b9f57f-f399-4682-8536-c86b827e7734', '1.95 Cts Blue Bicolour Tourmaline', 'Top Quality Neon Blue Bicolour Tourmaline Emerald Cut 

rare find

1.95 Cts 
15.1 x 3.7 x 3.4mm

No Treatment Whatsoever.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 268, 1, 'loose_stone', 'Tourmaline', NULL, 1.95, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/77b9f57f-f399-4682-8536-c86b827e7734/etsy-1.jpg","https://media.gemworkers.com/items/77b9f57f-f399-4682-8536-c86b827e7734/etsy-2.jpg","https://media.gemworkers.com/items/77b9f57f-f399-4682-8536-c86b827e7734/etsy-3.jpg","https://media.gemworkers.com/items/77b9f57f-f399-4682-8536-c86b827e7734/etsy-4.jpg","https://media.gemworkers.com/items/77b9f57f-f399-4682-8536-c86b827e7734/etsy-5.jpg","https://media.gemworkers.com/items/77b9f57f-f399-4682-8536-c86b827e7734/etsy-6.jpg","https://media.gemworkers.com/items/77b9f57f-f399-4682-8536-c86b827e7734/etsy-7.jpg","https://media.gemworkers.com/items/77b9f57f-f399-4682-8536-c86b827e7734/etsy-8.jpg","https://media.gemworkers.com/items/77b9f57f-f399-4682-8536-c86b827e7734/etsy-9.jpg","https://media.gemworkers.com/items/77b9f57f-f399-4682-8536-c86b827e7734/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 300 USD, converted at ECB rate. Etsy tags: Emerald Cut,EmeraldCutTourmaline,Jewellery making,earrings stud,Tourmaline Lot,Blue Tourmaline,Lagoon Tourmaline,Neon Blue,neon blue tourmaline,Rings For Men,Tourmalines,Ink Blue Tourmaline,Oceangemsminerals.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('2cccc910-b18b-4d03-82e3-02f1f9fac55e', '8.30 Cts Trillion Cut Pink Tourmalines', 'Natural Pink Rubilite Tourmaline

Trillion Cut 

8.30 carats   

8.6x8.6x4.4mm
9.1x9.1x59mm
9.5x9.4x6.1mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 268, 1, 'loose_stone', 'Tourmaline', NULL, 8.3, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/2cccc910-b18b-4d03-82e3-02f1f9fac55e/etsy-1.jpg","https://media.gemworkers.com/items/2cccc910-b18b-4d03-82e3-02f1f9fac55e/etsy-2.jpg","https://media.gemworkers.com/items/2cccc910-b18b-4d03-82e3-02f1f9fac55e/etsy-3.jpg","https://media.gemworkers.com/items/2cccc910-b18b-4d03-82e3-02f1f9fac55e/etsy-4.jpg","https://media.gemworkers.com/items/2cccc910-b18b-4d03-82e3-02f1f9fac55e/etsy-5.jpg","https://media.gemworkers.com/items/2cccc910-b18b-4d03-82e3-02f1f9fac55e/etsy-6.jpg","https://media.gemworkers.com/items/2cccc910-b18b-4d03-82e3-02f1f9fac55e/etsy-7.jpg","https://media.gemworkers.com/items/2cccc910-b18b-4d03-82e3-02f1f9fac55e/etsy-8.jpg","https://media.gemworkers.com/items/2cccc910-b18b-4d03-82e3-02f1f9fac55e/etsy-9.jpg","https://media.gemworkers.com/items/2cccc910-b18b-4d03-82e3-02f1f9fac55e/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 300 USD, converted at ECB rate. Etsy tags: trillion Cut,Pink Tourmalines,Tourmaline Set,Pink Tourmaline Set,Orange Tourmaline,Jewellery Making,Jewellery Supplies,Jewellery Findings,Natural Stone,Gold Rings,Tourmaline Lot,Tourmaline Pairs,Loose Gemstones.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('ff717cf2-87e3-42af-8060-7a15e6e3bf3f', '16.60 Cts Bicolour Tourmaline', 'Natural bicolour mesmerising tourmaline 

16.60 carats   
Size:15 x12.3x10.2mm

unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 893, 1, 'loose_stone', 'Tourmaline', NULL, 16.6, 'ct', NULL, NULL, '15 x12.3x10.2', '["https://media.gemworkers.com/items/ff717cf2-87e3-42af-8060-7a15e6e3bf3f/etsy-1.jpg","https://media.gemworkers.com/items/ff717cf2-87e3-42af-8060-7a15e6e3bf3f/etsy-2.jpg","https://media.gemworkers.com/items/ff717cf2-87e3-42af-8060-7a15e6e3bf3f/etsy-3.jpg","https://media.gemworkers.com/items/ff717cf2-87e3-42af-8060-7a15e6e3bf3f/etsy-4.jpg","https://media.gemworkers.com/items/ff717cf2-87e3-42af-8060-7a15e6e3bf3f/etsy-5.jpg","https://media.gemworkers.com/items/ff717cf2-87e3-42af-8060-7a15e6e3bf3f/etsy-6.jpg","https://media.gemworkers.com/items/ff717cf2-87e3-42af-8060-7a15e6e3bf3f/etsy-7.jpg","https://media.gemworkers.com/items/ff717cf2-87e3-42af-8060-7a15e6e3bf3f/etsy-8.jpg","https://media.gemworkers.com/items/ff717cf2-87e3-42af-8060-7a15e6e3bf3f/etsy-9.jpg","https://media.gemworkers.com/items/ff717cf2-87e3-42af-8060-7a15e6e3bf3f/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 1000 USD, converted at ECB rate. Etsy tags: Rings for women,rings for men,natural stone,gift for her,jewellery making,jewellery supplies,jewellery findings,bicolour tourmaline,pink tourmaline,stud jewellery,tourmaline emerald,emerald cut,green tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('160c084c-03ae-4cc7-bef8-91706fba7ad6', '1.6 Cts Sunset Tourmaline', 'A Very Unique Real Sunset Colour Tourmaline 

Gorgeous, Lustre And Brilliance 

1.60 Cts
6.8 x 6.2 x 4.9mm

Unheated,Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 107, 1, 'loose_stone', 'Tourmaline', NULL, 1.6, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/160c084c-03ae-4cc7-bef8-91706fba7ad6/etsy-1.jpg","https://media.gemworkers.com/items/160c084c-03ae-4cc7-bef8-91706fba7ad6/etsy-2.jpg","https://media.gemworkers.com/items/160c084c-03ae-4cc7-bef8-91706fba7ad6/etsy-3.jpg","https://media.gemworkers.com/items/160c084c-03ae-4cc7-bef8-91706fba7ad6/etsy-4.jpg","https://media.gemworkers.com/items/160c084c-03ae-4cc7-bef8-91706fba7ad6/etsy-5.jpg","https://media.gemworkers.com/items/160c084c-03ae-4cc7-bef8-91706fba7ad6/etsy-6.jpg","https://media.gemworkers.com/items/160c084c-03ae-4cc7-bef8-91706fba7ad6/etsy-7.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 120 USD, converted at ECB rate. Etsy tags: Sunset Tourmaline,Yellow Tourmaline,Bicolour Tourmaline,Brown Tourmaline,Tourmaline Rings,Bicolour Rings,Tourmaline Jewellery,Unique Bicolour,Unique Tourmaline,Rings For Men,Rings For Women,Handmade Jewellery,Jewellery Findings.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('84bf2a3d-19d6-4167-82a2-342587e3f768', '4 Cts, Blue Green Tourmaline', 'Gorgeous Mesmerising Blue Green Afghan Tourmaline 

Unique Colour 

4 cts

7.7 x 6.4 x 4 mm 
8.4 x 6.6 x 5.4 mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 356, 1, 'loose_stone', 'Tourmaline', NULL, 4, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/84bf2a3d-19d6-4167-82a2-342587e3f768/etsy-1.jpg","https://media.gemworkers.com/items/84bf2a3d-19d6-4167-82a2-342587e3f768/etsy-2.jpg","https://media.gemworkers.com/items/84bf2a3d-19d6-4167-82a2-342587e3f768/etsy-3.jpg","https://media.gemworkers.com/items/84bf2a3d-19d6-4167-82a2-342587e3f768/etsy-4.jpg","https://media.gemworkers.com/items/84bf2a3d-19d6-4167-82a2-342587e3f768/etsy-5.jpg","https://media.gemworkers.com/items/84bf2a3d-19d6-4167-82a2-342587e3f768/etsy-6.jpg","https://media.gemworkers.com/items/84bf2a3d-19d6-4167-82a2-342587e3f768/etsy-7.jpg","https://media.gemworkers.com/items/84bf2a3d-19d6-4167-82a2-342587e3f768/etsy-8.jpg","https://media.gemworkers.com/items/84bf2a3d-19d6-4167-82a2-342587e3f768/etsy-9.jpg","https://media.gemworkers.com/items/84bf2a3d-19d6-4167-82a2-342587e3f768/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 399 USD, converted at ECB rate. Etsy tags: BlueGreen Tourmaline,Blue Tourmaline,Green Tourmaline,Lagoon Tourmaline,Neon Tourmaline,Tourmaline Rings,rings for women,rings for men,jewellery making,jewellery supplies,jewellery findings,gift for her,natural stone.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('4a5eef1c-0b08-49ce-bf2d-06a19dc9cb2c', '6.75 Cts Ink Blue Tourmalines', 'Gorgeous Mesmerising Rare Ink Blue Colour Afghan Tourmaline 

Open Colour, Exceptional piece

6.75 cts

Size:5mm to 7.9mm

unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 535, 1, 'loose_stone', 'Tourmaline', NULL, 6.75, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/4a5eef1c-0b08-49ce-bf2d-06a19dc9cb2c/etsy-1.jpg","https://media.gemworkers.com/items/4a5eef1c-0b08-49ce-bf2d-06a19dc9cb2c/etsy-2.jpg","https://media.gemworkers.com/items/4a5eef1c-0b08-49ce-bf2d-06a19dc9cb2c/etsy-3.jpg","https://media.gemworkers.com/items/4a5eef1c-0b08-49ce-bf2d-06a19dc9cb2c/etsy-4.jpg","https://media.gemworkers.com/items/4a5eef1c-0b08-49ce-bf2d-06a19dc9cb2c/etsy-5.jpg","https://media.gemworkers.com/items/4a5eef1c-0b08-49ce-bf2d-06a19dc9cb2c/etsy-6.jpg","https://media.gemworkers.com/items/4a5eef1c-0b08-49ce-bf2d-06a19dc9cb2c/etsy-7.jpg","https://media.gemworkers.com/items/4a5eef1c-0b08-49ce-bf2d-06a19dc9cb2c/etsy-8.jpg","https://media.gemworkers.com/items/4a5eef1c-0b08-49ce-bf2d-06a19dc9cb2c/etsy-9.jpg","https://media.gemworkers.com/items/4a5eef1c-0b08-49ce-bf2d-06a19dc9cb2c/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 599 USD, converted at ECB rate. Etsy tags: Gold Rings,Rings For Men,Rings For Women,Tourmaline Jewellery,Natural Stone,bicolour Tourmaline,Lagoon tourmaline,Bluegreen tourmaline,blue tourmaline,indigo tourmaline,Oceangemsminerals,rare tourmaline,ink blue tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('7e1e8af8-b473-4a10-a238-cfcfd085dd99', '7.9 Cts Ink Blue Tourmalines', 'Gorgeous Mesmerising Rare Ink Blue Colour Afghan Tourmaline 

Open Colour, Exceptional piece

7.90 Cts 
Size:6.2x6.1x4.5mm to 7.8x7.1x5.9mm

unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 581, 1, 'loose_stone', 'Tourmaline', NULL, 7.9, 'ct', 'Afghanistan', NULL, '6.2x6.1x4.5', '["https://media.gemworkers.com/items/7e1e8af8-b473-4a10-a238-cfcfd085dd99/etsy-1.jpg","https://media.gemworkers.com/items/7e1e8af8-b473-4a10-a238-cfcfd085dd99/etsy-2.jpg","https://media.gemworkers.com/items/7e1e8af8-b473-4a10-a238-cfcfd085dd99/etsy-3.jpg","https://media.gemworkers.com/items/7e1e8af8-b473-4a10-a238-cfcfd085dd99/etsy-4.jpg","https://media.gemworkers.com/items/7e1e8af8-b473-4a10-a238-cfcfd085dd99/etsy-5.jpg","https://media.gemworkers.com/items/7e1e8af8-b473-4a10-a238-cfcfd085dd99/etsy-6.jpg","https://media.gemworkers.com/items/7e1e8af8-b473-4a10-a238-cfcfd085dd99/etsy-7.jpg","https://media.gemworkers.com/items/7e1e8af8-b473-4a10-a238-cfcfd085dd99/etsy-8.jpg","https://media.gemworkers.com/items/7e1e8af8-b473-4a10-a238-cfcfd085dd99/etsy-9.jpg","https://media.gemworkers.com/items/7e1e8af8-b473-4a10-a238-cfcfd085dd99/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 650 USD, converted at ECB rate. Etsy tags: Gold Rings,Rings For Men,Rings For Women,Tourmaline Jewellery,Natural Stone,bicolour Tourmaline,Lagoon tourmaline,Bluegreen tourmaline,blue tourmaline,indigo tourmaline,Oceangemsminerals,rare tourmaline,ink blue tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('9e077c3c-84c2-461c-9c26-dc0afe2a9ecf', '2.25 Cts Vibrant Green Tourmaline', 'Beautiful Apple green tourmaline 

Inclusion give it special characteristics 

2.25 cts
8.1x6.7x4.7mm

Unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 178, 1, 'loose_stone', 'Tourmaline', NULL, 2.25, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/9e077c3c-84c2-461c-9c26-dc0afe2a9ecf/etsy-1.jpg","https://media.gemworkers.com/items/9e077c3c-84c2-461c-9c26-dc0afe2a9ecf/etsy-2.jpg","https://media.gemworkers.com/items/9e077c3c-84c2-461c-9c26-dc0afe2a9ecf/etsy-3.jpg","https://media.gemworkers.com/items/9e077c3c-84c2-461c-9c26-dc0afe2a9ecf/etsy-4.jpg","https://media.gemworkers.com/items/9e077c3c-84c2-461c-9c26-dc0afe2a9ecf/etsy-5.jpg","https://media.gemworkers.com/items/9e077c3c-84c2-461c-9c26-dc0afe2a9ecf/etsy-6.jpg","https://media.gemworkers.com/items/9e077c3c-84c2-461c-9c26-dc0afe2a9ecf/etsy-7.jpg","https://media.gemworkers.com/items/9e077c3c-84c2-461c-9c26-dc0afe2a9ecf/etsy-8.jpg","https://media.gemworkers.com/items/9e077c3c-84c2-461c-9c26-dc0afe2a9ecf/etsy-9.jpg","https://media.gemworkers.com/items/9e077c3c-84c2-461c-9c26-dc0afe2a9ecf/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 199 USD, converted at ECB rate. Etsy tags: Green Tourmaline,Vibrant Tourmaline,AppleGreenTourmaline,Tourmaline jewellery,jewellers,jewellery making,jewellery supplies,jewellery findings,Oceangemsminerals,rings for women,rings for men,rings jewellery,natural stone.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('39113e85-30bc-4284-8792-b3ca91bd965c', '6.95 Cts Lagoon Tourmaline Lot', 'Lagoon And blue colour tourmaline Lot

mesmerising rare colours

6.95 cts
6mm to 6.7mm

no treatment whatsoever.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 621, 1, 'loose_stone', 'Tourmaline', NULL, 6.95, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/39113e85-30bc-4284-8792-b3ca91bd965c/etsy-1.jpg","https://media.gemworkers.com/items/39113e85-30bc-4284-8792-b3ca91bd965c/etsy-2.jpg","https://media.gemworkers.com/items/39113e85-30bc-4284-8792-b3ca91bd965c/etsy-3.jpg","https://media.gemworkers.com/items/39113e85-30bc-4284-8792-b3ca91bd965c/etsy-4.jpg","https://media.gemworkers.com/items/39113e85-30bc-4284-8792-b3ca91bd965c/etsy-5.jpg","https://media.gemworkers.com/items/39113e85-30bc-4284-8792-b3ca91bd965c/etsy-6.jpg","https://media.gemworkers.com/items/39113e85-30bc-4284-8792-b3ca91bd965c/etsy-7.jpg","https://media.gemworkers.com/items/39113e85-30bc-4284-8792-b3ca91bd965c/etsy-8.jpg","https://media.gemworkers.com/items/39113e85-30bc-4284-8792-b3ca91bd965c/etsy-9.jpg","https://media.gemworkers.com/items/39113e85-30bc-4284-8792-b3ca91bd965c/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 695 USD, converted at ECB rate. Etsy tags: Tourmaline Jewellery,Tourmaline Rings,Blue Tourmaline,Gift For Her,Rings For Women,Rings For Men,Gold Rings,Natural Stone,lagoon tourmaline,indigo tourmaline,indicolitetourmaline,Oceangemsminerals,ink blue tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('015327c0-7258-4cd4-a6f8-5f27a3e5ca1e', '1.55 Cts Indigo blue Tourmaline', 'indigo blue colour tourmaline 

mesmerising rare colour, cute looking tourmaline.

1.55 cts 
7.2 x 6 x 4.4 mm

no treatment whatsoever.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 223, 1, 'loose_stone', 'Tourmaline', NULL, 1.55, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/015327c0-7258-4cd4-a6f8-5f27a3e5ca1e/etsy-1.jpg","https://media.gemworkers.com/items/015327c0-7258-4cd4-a6f8-5f27a3e5ca1e/etsy-2.jpg","https://media.gemworkers.com/items/015327c0-7258-4cd4-a6f8-5f27a3e5ca1e/etsy-3.jpg","https://media.gemworkers.com/items/015327c0-7258-4cd4-a6f8-5f27a3e5ca1e/etsy-4.jpg","https://media.gemworkers.com/items/015327c0-7258-4cd4-a6f8-5f27a3e5ca1e/etsy-5.jpg","https://media.gemworkers.com/items/015327c0-7258-4cd4-a6f8-5f27a3e5ca1e/etsy-6.jpg","https://media.gemworkers.com/items/015327c0-7258-4cd4-a6f8-5f27a3e5ca1e/etsy-7.jpg","https://media.gemworkers.com/items/015327c0-7258-4cd4-a6f8-5f27a3e5ca1e/etsy-8.jpg","https://media.gemworkers.com/items/015327c0-7258-4cd4-a6f8-5f27a3e5ca1e/etsy-9.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 250 USD, converted at ECB rate. Etsy tags: Tourmaline Jewellery,Tourmaline Rings,Blue Tourmaline,Gift For Her,Rings For Women,Rings For Men,Gold Rings,Natural Stone,lagoon tourmaline,indigo tourmaline,indicolitetourmaline,Oceangemsminerals,ink blue tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('2ca410b4-18ef-47a3-9883-cc0dfeb1f02f', '1.2 Cts Indicolite Tourmaline', 'Top Indicolite Colour Tourmaline Emerald Cut 

rare find

1.20 cts
6.8 x 5.4 x 3.7 mm

No Treatment Whatsoever.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 214, 1, 'loose_stone', 'Tourmaline', 'Indicolite', 1.2, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/2ca410b4-18ef-47a3-9883-cc0dfeb1f02f/etsy-1.jpg","https://media.gemworkers.com/items/2ca410b4-18ef-47a3-9883-cc0dfeb1f02f/etsy-2.jpg","https://media.gemworkers.com/items/2ca410b4-18ef-47a3-9883-cc0dfeb1f02f/etsy-3.jpg","https://media.gemworkers.com/items/2ca410b4-18ef-47a3-9883-cc0dfeb1f02f/etsy-4.jpg","https://media.gemworkers.com/items/2ca410b4-18ef-47a3-9883-cc0dfeb1f02f/etsy-5.jpg","https://media.gemworkers.com/items/2ca410b4-18ef-47a3-9883-cc0dfeb1f02f/etsy-6.jpg","https://media.gemworkers.com/items/2ca410b4-18ef-47a3-9883-cc0dfeb1f02f/etsy-7.jpg","https://media.gemworkers.com/items/2ca410b4-18ef-47a3-9883-cc0dfeb1f02f/etsy-8.jpg","https://media.gemworkers.com/items/2ca410b4-18ef-47a3-9883-cc0dfeb1f02f/etsy-9.jpg","https://media.gemworkers.com/items/2ca410b4-18ef-47a3-9883-cc0dfeb1f02f/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 240 USD, converted at ECB rate. Etsy tags: Emerald Cut,EmeraldCutTourmaline,Jewellery making,earrings stud,Tourmaline Lot,Blue Tourmaline,Lagoon Tourmaline,Neon Blue,neon blue tourmaline,Rings For Men,Tourmalines,Ink Blue Tourmaline,Oceangemsminerals.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('e088f7a7-836d-4d51-be45-5016992d6cc9', '1.85 Cts Mint Green tourmalines', 'Mesmerising Mint Green Colour Tourmaline 

High Lustre And Brilliance , Top Colours

Perfectly Cut 

1.85 cts
Size:4.7 mm to 5.4mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 178, 1, 'loose_stone', 'Tourmaline', NULL, 1.85, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/e088f7a7-836d-4d51-be45-5016992d6cc9/etsy-1.jpg","https://media.gemworkers.com/items/e088f7a7-836d-4d51-be45-5016992d6cc9/etsy-2.jpg","https://media.gemworkers.com/items/e088f7a7-836d-4d51-be45-5016992d6cc9/etsy-3.jpg","https://media.gemworkers.com/items/e088f7a7-836d-4d51-be45-5016992d6cc9/etsy-4.jpg","https://media.gemworkers.com/items/e088f7a7-836d-4d51-be45-5016992d6cc9/etsy-5.jpg","https://media.gemworkers.com/items/e088f7a7-836d-4d51-be45-5016992d6cc9/etsy-6.jpg","https://media.gemworkers.com/items/e088f7a7-836d-4d51-be45-5016992d6cc9/etsy-7.jpg","https://media.gemworkers.com/items/e088f7a7-836d-4d51-be45-5016992d6cc9/etsy-8.jpg","https://media.gemworkers.com/items/e088f7a7-836d-4d51-be45-5016992d6cc9/etsy-9.jpg","https://media.gemworkers.com/items/e088f7a7-836d-4d51-be45-5016992d6cc9/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 199 USD, converted at ECB rate. Etsy tags: Gift For Her,Rings For Men,Rings For Women,Natural Stone,Silver Sterling,Gold Ring,Tourmaline Jewellery,Seafoam Tourmaline,Mint Tourmaline,Blue Tourmaline,Bluegreen tourmaline,lagoon tourmaline,Oceangemsminerals.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('b96e13fa-fc88-451f-94bd-1dfc4a375536', '0.8 Cts Indicolite Tourmaline', 'Top Indicolite Colour Tourmaline Emerald Cut 

rare find

0.80 Cts

Size:6.9x4x3.2mm

No Treatment Whatsoever.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 71, 1, 'loose_stone', 'Tourmaline', 'Indicolite', 0.8, 'ct', NULL, NULL, '6.9x4x3.2', '["https://media.gemworkers.com/items/b96e13fa-fc88-451f-94bd-1dfc4a375536/etsy-1.jpg","https://media.gemworkers.com/items/b96e13fa-fc88-451f-94bd-1dfc4a375536/etsy-2.jpg","https://media.gemworkers.com/items/b96e13fa-fc88-451f-94bd-1dfc4a375536/etsy-3.jpg","https://media.gemworkers.com/items/b96e13fa-fc88-451f-94bd-1dfc4a375536/etsy-4.jpg","https://media.gemworkers.com/items/b96e13fa-fc88-451f-94bd-1dfc4a375536/etsy-5.jpg","https://media.gemworkers.com/items/b96e13fa-fc88-451f-94bd-1dfc4a375536/etsy-6.jpg","https://media.gemworkers.com/items/b96e13fa-fc88-451f-94bd-1dfc4a375536/etsy-7.jpg","https://media.gemworkers.com/items/b96e13fa-fc88-451f-94bd-1dfc4a375536/etsy-8.jpg","https://media.gemworkers.com/items/b96e13fa-fc88-451f-94bd-1dfc4a375536/etsy-9.jpg","https://media.gemworkers.com/items/b96e13fa-fc88-451f-94bd-1dfc4a375536/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 80 USD, converted at ECB rate. Etsy tags: Emerald Cut,EmeraldCutTourmaline,Jewellery making,earrings stud,Tourmaline Lot,Blue Tourmaline,Lagoon Tourmaline,Neon Blue,neon blue tourmaline,Rings For Men,Tourmalines,Ink Blue Tourmaline,Oceangemsminerals.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('ba6dafb6-346a-414c-969d-9ff7a73cac28', '1.3 Cts Spinel From Burma', 'A Very Unique Spinel 

Purplish Pink Colour

Bright And Brilliance 

1.3 Cts
6.7 x 6.7 x 3.8mm

Unheated, Untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 214, 1, 'loose_stone', 'Spinel', NULL, 1.3, 'ct', 'Myanmar', NULL, NULL, '["https://media.gemworkers.com/items/ba6dafb6-346a-414c-969d-9ff7a73cac28/etsy-1.jpg","https://media.gemworkers.com/items/ba6dafb6-346a-414c-969d-9ff7a73cac28/etsy-2.jpg","https://media.gemworkers.com/items/ba6dafb6-346a-414c-969d-9ff7a73cac28/etsy-3.jpg","https://media.gemworkers.com/items/ba6dafb6-346a-414c-969d-9ff7a73cac28/etsy-4.jpg","https://media.gemworkers.com/items/ba6dafb6-346a-414c-969d-9ff7a73cac28/etsy-5.jpg","https://media.gemworkers.com/items/ba6dafb6-346a-414c-969d-9ff7a73cac28/etsy-6.jpg","https://media.gemworkers.com/items/ba6dafb6-346a-414c-969d-9ff7a73cac28/etsy-7.jpg","https://media.gemworkers.com/items/ba6dafb6-346a-414c-969d-9ff7a73cac28/etsy-8.jpg","https://media.gemworkers.com/items/ba6dafb6-346a-414c-969d-9ff7a73cac28/etsy-9.jpg","https://media.gemworkers.com/items/ba6dafb6-346a-414c-969d-9ff7a73cac28/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 240 USD, converted at ECB rate. Etsy tags: Spinel Jewellery,Spinel Rings,Pink Spinel,Orange Spinel,Bicolour Spinel,Unique Spinel,Faceted Spinel,Jewellery Making,Jewellery Supplies,Oceangemsminerals,Spinel Necklace,Gift For Her,Natural Stone.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('fbdf5fe6-69ec-45e0-9ef0-1c7f13a4251a', '1.4 Cts Spinel From Burma', 'A Very Unique Spinel 

Purplish Pink Colour

Bright And Brilliance 

1.4 Cts
6.7 x 6.2 x 3.9mm

Unheated, Untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 214, 1, 'loose_stone', 'Spinel', NULL, 1.4, 'ct', 'Myanmar', NULL, NULL, '["https://media.gemworkers.com/items/fbdf5fe6-69ec-45e0-9ef0-1c7f13a4251a/etsy-1.jpg","https://media.gemworkers.com/items/fbdf5fe6-69ec-45e0-9ef0-1c7f13a4251a/etsy-2.jpg","https://media.gemworkers.com/items/fbdf5fe6-69ec-45e0-9ef0-1c7f13a4251a/etsy-3.jpg","https://media.gemworkers.com/items/fbdf5fe6-69ec-45e0-9ef0-1c7f13a4251a/etsy-4.jpg","https://media.gemworkers.com/items/fbdf5fe6-69ec-45e0-9ef0-1c7f13a4251a/etsy-5.jpg","https://media.gemworkers.com/items/fbdf5fe6-69ec-45e0-9ef0-1c7f13a4251a/etsy-6.jpg","https://media.gemworkers.com/items/fbdf5fe6-69ec-45e0-9ef0-1c7f13a4251a/etsy-7.jpg","https://media.gemworkers.com/items/fbdf5fe6-69ec-45e0-9ef0-1c7f13a4251a/etsy-8.jpg","https://media.gemworkers.com/items/fbdf5fe6-69ec-45e0-9ef0-1c7f13a4251a/etsy-9.jpg","https://media.gemworkers.com/items/fbdf5fe6-69ec-45e0-9ef0-1c7f13a4251a/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 240 USD, converted at ECB rate. Etsy tags: Spinel Jewellery,Spinel Rings,Pink Spinel,Orange Spinel,Bicolour Spinel,Unique Spinel,Faceted Spinel,Jewellery Making,Jewellery Supplies,Oceangemsminerals,Spinel Necklace,Gift For Her,Natural Stone.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('3f96ecd8-0636-4267-800a-b5c3b83bc9e2', '1.6 Cts Spinel From Burma', 'A Very Unique Spinel 

Purple Colour

Bright And Brilliance 

1.6 Cts
7.7 x 5.7 x 3.8mm

Unheated, Untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 214, 1, 'loose_stone', 'Spinel', NULL, 1.6, 'ct', 'Myanmar', NULL, NULL, '["https://media.gemworkers.com/items/3f96ecd8-0636-4267-800a-b5c3b83bc9e2/etsy-1.jpg","https://media.gemworkers.com/items/3f96ecd8-0636-4267-800a-b5c3b83bc9e2/etsy-2.jpg","https://media.gemworkers.com/items/3f96ecd8-0636-4267-800a-b5c3b83bc9e2/etsy-3.jpg","https://media.gemworkers.com/items/3f96ecd8-0636-4267-800a-b5c3b83bc9e2/etsy-4.jpg","https://media.gemworkers.com/items/3f96ecd8-0636-4267-800a-b5c3b83bc9e2/etsy-5.jpg","https://media.gemworkers.com/items/3f96ecd8-0636-4267-800a-b5c3b83bc9e2/etsy-6.jpg","https://media.gemworkers.com/items/3f96ecd8-0636-4267-800a-b5c3b83bc9e2/etsy-7.jpg","https://media.gemworkers.com/items/3f96ecd8-0636-4267-800a-b5c3b83bc9e2/etsy-8.jpg","https://media.gemworkers.com/items/3f96ecd8-0636-4267-800a-b5c3b83bc9e2/etsy-9.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 240 USD, converted at ECB rate. Etsy tags: Spinel Jewellery,Spinel Rings,Pink Spinel,Orange Spinel,Bicolour Spinel,Unique Spinel,Faceted Spinel,Jewellery Making,Jewellery Supplies,Oceangemsminerals,Spinel Necklace,Gift For Her,Natural Stone.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('b9623461-42f5-4a6f-91d4-914095057dd4', '1.8 Cts Spinel From Burma', 'A Very Unique Spinel 

Purplish Pink Colour

Bright And Brilliance 

1.8 Cts
8.1 x 6.1 x 4.1mm

Unheated, Untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 214, 1, 'loose_stone', 'Spinel', NULL, 1.8, 'ct', 'Myanmar', NULL, NULL, '["https://media.gemworkers.com/items/b9623461-42f5-4a6f-91d4-914095057dd4/etsy-1.jpg","https://media.gemworkers.com/items/b9623461-42f5-4a6f-91d4-914095057dd4/etsy-2.jpg","https://media.gemworkers.com/items/b9623461-42f5-4a6f-91d4-914095057dd4/etsy-3.jpg","https://media.gemworkers.com/items/b9623461-42f5-4a6f-91d4-914095057dd4/etsy-4.jpg","https://media.gemworkers.com/items/b9623461-42f5-4a6f-91d4-914095057dd4/etsy-5.jpg","https://media.gemworkers.com/items/b9623461-42f5-4a6f-91d4-914095057dd4/etsy-6.jpg","https://media.gemworkers.com/items/b9623461-42f5-4a6f-91d4-914095057dd4/etsy-7.jpg","https://media.gemworkers.com/items/b9623461-42f5-4a6f-91d4-914095057dd4/etsy-8.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 240 USD, converted at ECB rate. Etsy tags: Spinel Jewellery,Spinel Rings,Pink Spinel,Orange Spinel,Bicolour Spinel,Unique Spinel,Faceted Spinel,Jewellery Making,Jewellery Supplies,Oceangemsminerals,Spinel Necklace,Gift For Her,Natural Stone.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('48ef139f-5723-45ec-9955-4a150a7a69f4', '1.4 Cts Spinel From Burma', 'A Very Unique Spinel 

Purplish Pink Colour

Bright And Brilliance 

1.4 Cts
7.4 x 5.8 x 4.4mm

Unheated, Untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 214, 1, 'loose_stone', 'Spinel', NULL, 1.4, 'ct', 'Myanmar', NULL, NULL, '["https://media.gemworkers.com/items/48ef139f-5723-45ec-9955-4a150a7a69f4/etsy-1.jpg","https://media.gemworkers.com/items/48ef139f-5723-45ec-9955-4a150a7a69f4/etsy-2.jpg","https://media.gemworkers.com/items/48ef139f-5723-45ec-9955-4a150a7a69f4/etsy-3.jpg","https://media.gemworkers.com/items/48ef139f-5723-45ec-9955-4a150a7a69f4/etsy-4.jpg","https://media.gemworkers.com/items/48ef139f-5723-45ec-9955-4a150a7a69f4/etsy-5.jpg","https://media.gemworkers.com/items/48ef139f-5723-45ec-9955-4a150a7a69f4/etsy-6.jpg","https://media.gemworkers.com/items/48ef139f-5723-45ec-9955-4a150a7a69f4/etsy-7.jpg","https://media.gemworkers.com/items/48ef139f-5723-45ec-9955-4a150a7a69f4/etsy-8.jpg","https://media.gemworkers.com/items/48ef139f-5723-45ec-9955-4a150a7a69f4/etsy-9.jpg","https://media.gemworkers.com/items/48ef139f-5723-45ec-9955-4a150a7a69f4/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 240 USD, converted at ECB rate. Etsy tags: Spinel Jewellery,Spinel Rings,Pink Spinel,Orange Spinel,Bicolour Spinel,Unique Spinel,Faceted Spinel,Jewellery Making,Jewellery Supplies,Oceangemsminerals,Spinel Necklace,Gift For Her,Natural Stone.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('994151f5-3ec3-487f-8dd2-9734d098aef8', '21 Multi Colour flourite Pair', 'Rare Colour Combinations 

Real Fluorite Pair 

Natural Stone

21 Cts
22.2 x 7.5 x 5.9mm

Unheated, Untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 268, 1, 'loose_stone', 'Fluorite', NULL, NULL, NULL, NULL, NULL, NULL, '["https://media.gemworkers.com/items/994151f5-3ec3-487f-8dd2-9734d098aef8/etsy-1.jpg","https://media.gemworkers.com/items/994151f5-3ec3-487f-8dd2-9734d098aef8/etsy-2.jpg","https://media.gemworkers.com/items/994151f5-3ec3-487f-8dd2-9734d098aef8/etsy-3.jpg","https://media.gemworkers.com/items/994151f5-3ec3-487f-8dd2-9734d098aef8/etsy-4.jpg","https://media.gemworkers.com/items/994151f5-3ec3-487f-8dd2-9734d098aef8/etsy-5.jpg","https://media.gemworkers.com/items/994151f5-3ec3-487f-8dd2-9734d098aef8/etsy-6.jpg","https://media.gemworkers.com/items/994151f5-3ec3-487f-8dd2-9734d098aef8/etsy-7.jpg","https://media.gemworkers.com/items/994151f5-3ec3-487f-8dd2-9734d098aef8/etsy-8.jpg","https://media.gemworkers.com/items/994151f5-3ec3-487f-8dd2-9734d098aef8/etsy-9.jpg","https://media.gemworkers.com/items/994151f5-3ec3-487f-8dd2-9734d098aef8/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 300 USD, converted at ECB rate. Etsy tags: Flourite Pair,Multi Colour Pair,Unique Pair,Rare Pair,Rare Colour Pairs,Rare Earrings,Flourite Jewellery,Bicolour Pair,Tricolour Pairs,Natural Stone,Gold Rings,Jewellery Supplies,Jewellery Findings.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('44070b73-27bb-45c3-856b-bc89067cc286', 'Raw Tourmaline Bracelet', 'Gorgeous Natural Tourmaline Bracelet', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 88, 1, 'jewelry', 'Tourmaline', NULL, NULL, NULL, NULL, NULL, NULL, '["https://media.gemworkers.com/items/44070b73-27bb-45c3-856b-bc89067cc286/etsy-1.jpg","https://media.gemworkers.com/items/44070b73-27bb-45c3-856b-bc89067cc286/etsy-2.jpg","https://media.gemworkers.com/items/44070b73-27bb-45c3-856b-bc89067cc286/etsy-3.jpg","https://media.gemworkers.com/items/44070b73-27bb-45c3-856b-bc89067cc286/etsy-4.jpg","https://media.gemworkers.com/items/44070b73-27bb-45c3-856b-bc89067cc286/etsy-5.jpg","https://media.gemworkers.com/items/44070b73-27bb-45c3-856b-bc89067cc286/etsy-6.jpg","https://media.gemworkers.com/items/44070b73-27bb-45c3-856b-bc89067cc286/etsy-7.jpg","https://media.gemworkers.com/items/44070b73-27bb-45c3-856b-bc89067cc286/etsy-8.jpg","https://media.gemworkers.com/items/44070b73-27bb-45c3-856b-bc89067cc286/etsy-9.jpg","https://media.gemworkers.com/items/44070b73-27bb-45c3-856b-bc89067cc286/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 99 USD, converted at ECB rate. Etsy tags: Raw Tourmaline,Tourmaline Jewellery,Tourmaline Bracelets,Tourmaline Crystals,Rough Tourmaline,Bracelets In Beads,Tourmaline Set,Beads Jewellery,Blue Tourmaline,Green Tourmaline,Tourmaline Catseye,Natural Stone,Gold Jewellery.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('3e1c3432-1772-4d1f-a0a2-fdf11ee86b2a', '6 Cts Pink Bicolour Tourmaline Pairs', 'Natural Pink bicolour mesmerising tourmaline Pairs

6 carats 

Size:5.2mm to 6.3mm

unheated, untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 447, 1, 'loose_stone', 'Tourmaline', NULL, 6, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/3e1c3432-1772-4d1f-a0a2-fdf11ee86b2a/etsy-1.jpg","https://media.gemworkers.com/items/3e1c3432-1772-4d1f-a0a2-fdf11ee86b2a/etsy-2.jpg","https://media.gemworkers.com/items/3e1c3432-1772-4d1f-a0a2-fdf11ee86b2a/etsy-3.jpg","https://media.gemworkers.com/items/3e1c3432-1772-4d1f-a0a2-fdf11ee86b2a/etsy-4.jpg","https://media.gemworkers.com/items/3e1c3432-1772-4d1f-a0a2-fdf11ee86b2a/etsy-5.jpg","https://media.gemworkers.com/items/3e1c3432-1772-4d1f-a0a2-fdf11ee86b2a/etsy-6.jpg","https://media.gemworkers.com/items/3e1c3432-1772-4d1f-a0a2-fdf11ee86b2a/etsy-7.jpg","https://media.gemworkers.com/items/3e1c3432-1772-4d1f-a0a2-fdf11ee86b2a/etsy-8.jpg","https://media.gemworkers.com/items/3e1c3432-1772-4d1f-a0a2-fdf11ee86b2a/etsy-9.jpg","https://media.gemworkers.com/items/3e1c3432-1772-4d1f-a0a2-fdf11ee86b2a/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 500 USD, converted at ECB rate. Etsy tags: Rings for women,rings for men,natural stone,gift for her,jewellery making,jewellery supplies,jewellery findings,bicolour tourmaline,pink tourmaline,stud jewellery,tourmaline emerald,emerald cut,green tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('f07e69ca-ba05-40a9-b02f-8d8214e20a83', '2.95 Cts Blue Bicolour Tourmaline', 'Top Quality Blue Bicolour Tourmaline Emerald Cut 

rare find

2.95 carats 

Size:5.7mm to 5.8mm

No Treatment Whatsoever.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 134, 1, 'loose_stone', 'Tourmaline', NULL, 2.95, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/f07e69ca-ba05-40a9-b02f-8d8214e20a83/etsy-1.jpg","https://media.gemworkers.com/items/f07e69ca-ba05-40a9-b02f-8d8214e20a83/etsy-2.jpg","https://media.gemworkers.com/items/f07e69ca-ba05-40a9-b02f-8d8214e20a83/etsy-3.jpg","https://media.gemworkers.com/items/f07e69ca-ba05-40a9-b02f-8d8214e20a83/etsy-4.jpg","https://media.gemworkers.com/items/f07e69ca-ba05-40a9-b02f-8d8214e20a83/etsy-5.jpg","https://media.gemworkers.com/items/f07e69ca-ba05-40a9-b02f-8d8214e20a83/etsy-6.jpg","https://media.gemworkers.com/items/f07e69ca-ba05-40a9-b02f-8d8214e20a83/etsy-7.jpg","https://media.gemworkers.com/items/f07e69ca-ba05-40a9-b02f-8d8214e20a83/etsy-8.jpg","https://media.gemworkers.com/items/f07e69ca-ba05-40a9-b02f-8d8214e20a83/etsy-9.jpg","https://media.gemworkers.com/items/f07e69ca-ba05-40a9-b02f-8d8214e20a83/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 150 USD, converted at ECB rate. Etsy tags: Emerald Cut,EmeraldCutTourmaline,Jewellery making,earrings stud,Tourmaline Lot,Blue Tourmaline,Lagoon Tourmaline,Neon Blue,neon blue tourmaline,Rings For Men,Tourmalines,Ink Blue Tourmaline,Oceangemsminerals.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('a86acf29-ebb2-45d0-ad55-040458229906', '3.10 Cts Honey Colour Tourmaline', 'Honey Colour Tourmaline 

unique colour, Unique Cut

3.10 Cts
10.4 x 10.2 x 5.6mm

no treatment', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 178, 1, 'loose_stone', 'Tourmaline', NULL, 3.1, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/a86acf29-ebb2-45d0-ad55-040458229906/etsy-1.jpg","https://media.gemworkers.com/items/a86acf29-ebb2-45d0-ad55-040458229906/etsy-2.jpg","https://media.gemworkers.com/items/a86acf29-ebb2-45d0-ad55-040458229906/etsy-3.jpg","https://media.gemworkers.com/items/a86acf29-ebb2-45d0-ad55-040458229906/etsy-4.jpg","https://media.gemworkers.com/items/a86acf29-ebb2-45d0-ad55-040458229906/etsy-5.jpg","https://media.gemworkers.com/items/a86acf29-ebb2-45d0-ad55-040458229906/etsy-6.jpg","https://media.gemworkers.com/items/a86acf29-ebb2-45d0-ad55-040458229906/etsy-7.jpg","https://media.gemworkers.com/items/a86acf29-ebb2-45d0-ad55-040458229906/etsy-8.jpg","https://media.gemworkers.com/items/a86acf29-ebb2-45d0-ad55-040458229906/etsy-9.jpg","https://media.gemworkers.com/items/a86acf29-ebb2-45d0-ad55-040458229906/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 199 USD, converted at ECB rate. Etsy tags: Tourmaline Jewellery,Jewellery Making,Jewellery supplies,jewellery findings,Gold Rings,Rings For Women,Natural Stone,Handmade,Gift For Her,Green Tourmaline,Cushion Cut,Tourmaline Rings,Rings Supplies.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('73edfd35-6611-48b0-996a-8a206c9366cc', '2.40 Cts Mints Green tourmaline', 'Mesmerising Mint Green Colour Tourmaline 

Small And Cute Piece, Good Colour.

2.40 Cts
8.8 x 8.8 x 5mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 89, 1, 'loose_stone', 'Tourmaline', NULL, 2.4, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/73edfd35-6611-48b0-996a-8a206c9366cc/etsy-1.jpg","https://media.gemworkers.com/items/73edfd35-6611-48b0-996a-8a206c9366cc/etsy-2.jpg","https://media.gemworkers.com/items/73edfd35-6611-48b0-996a-8a206c9366cc/etsy-3.jpg","https://media.gemworkers.com/items/73edfd35-6611-48b0-996a-8a206c9366cc/etsy-4.jpg","https://media.gemworkers.com/items/73edfd35-6611-48b0-996a-8a206c9366cc/etsy-5.jpg","https://media.gemworkers.com/items/73edfd35-6611-48b0-996a-8a206c9366cc/etsy-6.jpg","https://media.gemworkers.com/items/73edfd35-6611-48b0-996a-8a206c9366cc/etsy-7.jpg","https://media.gemworkers.com/items/73edfd35-6611-48b0-996a-8a206c9366cc/etsy-8.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 100 USD, converted at ECB rate. Etsy tags: Gift For Her,Rings For Men,Rings For Women,Natural Stone,Silver Sterling,Gold Ring,Tourmaline Jewellery,Seafoam Tourmaline,Mint Tourmaline,Blue Tourmaline,Bluegreen tourmaline,lagoon tourmaline,Oceangemsminerals.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('3c918774-9a5e-4526-bf83-f5a38f9a304b', '23.35 Cts Vibrant Green Tourmaline', 'Beautiful big size green tourmaline 

Inclusion give it special characteristics 

23.35 Cts
19 x 13.2 x 10.4mm

Unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 536, 1, 'loose_stone', 'Tourmaline', NULL, 23.35, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/3c918774-9a5e-4526-bf83-f5a38f9a304b/etsy-1.jpg","https://media.gemworkers.com/items/3c918774-9a5e-4526-bf83-f5a38f9a304b/etsy-2.jpg","https://media.gemworkers.com/items/3c918774-9a5e-4526-bf83-f5a38f9a304b/etsy-3.jpg","https://media.gemworkers.com/items/3c918774-9a5e-4526-bf83-f5a38f9a304b/etsy-4.jpg","https://media.gemworkers.com/items/3c918774-9a5e-4526-bf83-f5a38f9a304b/etsy-5.jpg","https://media.gemworkers.com/items/3c918774-9a5e-4526-bf83-f5a38f9a304b/etsy-6.jpg","https://media.gemworkers.com/items/3c918774-9a5e-4526-bf83-f5a38f9a304b/etsy-7.jpg","https://media.gemworkers.com/items/3c918774-9a5e-4526-bf83-f5a38f9a304b/etsy-8.jpg","https://media.gemworkers.com/items/3c918774-9a5e-4526-bf83-f5a38f9a304b/etsy-9.jpg","https://media.gemworkers.com/items/3c918774-9a5e-4526-bf83-f5a38f9a304b/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 600 USD, converted at ECB rate. Etsy tags: Green Tourmaline,Vibrant Tourmaline,AppleGreenTourmaline,Tourmaline jewellery,jewellers,jewellery making,jewellery supplies,jewellery findings,Oceangemsminerals,rings for women,rings for men,rings jewellery,natural stone.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('78c8050e-92b9-4f91-8f9c-afca0e50d7cf', 'Yellow Citrine, 83.20 Cts', 'Yellow Citrine For Jewellery 

Necklace And rings Useable beautiful cut and

83.20 Cts

19 x 14 x 11mm
17.5 x 14 x 11mm
19 x 11 x 10mm

no treatment.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 179, 1, 'loose_stone', 'Quartz', 'Citrine', 83.2, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/78c8050e-92b9-4f91-8f9c-afca0e50d7cf/etsy-1.jpg","https://media.gemworkers.com/items/78c8050e-92b9-4f91-8f9c-afca0e50d7cf/etsy-2.jpg","https://media.gemworkers.com/items/78c8050e-92b9-4f91-8f9c-afca0e50d7cf/etsy-3.jpg","https://media.gemworkers.com/items/78c8050e-92b9-4f91-8f9c-afca0e50d7cf/etsy-4.jpg","https://media.gemworkers.com/items/78c8050e-92b9-4f91-8f9c-afca0e50d7cf/etsy-5.jpg","https://media.gemworkers.com/items/78c8050e-92b9-4f91-8f9c-afca0e50d7cf/etsy-6.jpg","https://media.gemworkers.com/items/78c8050e-92b9-4f91-8f9c-afca0e50d7cf/etsy-7.jpg","https://media.gemworkers.com/items/78c8050e-92b9-4f91-8f9c-afca0e50d7cf/etsy-8.jpg","https://media.gemworkers.com/items/78c8050e-92b9-4f91-8f9c-afca0e50d7cf/etsy-9.jpg","https://media.gemworkers.com/items/78c8050e-92b9-4f91-8f9c-afca0e50d7cf/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 200 USD, converted at ECB rate. Etsy tags: Rings For Women,Natural Stone,Handmade,Jewellery making,jewellery supplies,jewellery findings,Gift for her,Gold Rings,stud jewellery,rings for men,citrine set,jewellery set,citrine jewellery.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('c041ef0f-aa0a-42d0-9e9b-4c83a3c0a6c1', 'Bicolor Tourmaline 3.20 Carats', 'bicolour mesmerising tourmaline 

Weight:3.20 carats 
Dimension: 8 x 8 x 6mm

no treatment.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 143, 1, 'loose_stone', 'Tourmaline', NULL, 3.2, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/c041ef0f-aa0a-42d0-9e9b-4c83a3c0a6c1/etsy-1.jpg","https://media.gemworkers.com/items/c041ef0f-aa0a-42d0-9e9b-4c83a3c0a6c1/etsy-2.jpg","https://media.gemworkers.com/items/c041ef0f-aa0a-42d0-9e9b-4c83a3c0a6c1/etsy-3.jpg","https://media.gemworkers.com/items/c041ef0f-aa0a-42d0-9e9b-4c83a3c0a6c1/etsy-4.jpg","https://media.gemworkers.com/items/c041ef0f-aa0a-42d0-9e9b-4c83a3c0a6c1/etsy-5.jpg","https://media.gemworkers.com/items/c041ef0f-aa0a-42d0-9e9b-4c83a3c0a6c1/etsy-6.jpg","https://media.gemworkers.com/items/c041ef0f-aa0a-42d0-9e9b-4c83a3c0a6c1/etsy-7.jpg","https://media.gemworkers.com/items/c041ef0f-aa0a-42d0-9e9b-4c83a3c0a6c1/etsy-8.jpg","https://media.gemworkers.com/items/c041ef0f-aa0a-42d0-9e9b-4c83a3c0a6c1/etsy-9.jpg","https://media.gemworkers.com/items/c041ef0f-aa0a-42d0-9e9b-4c83a3c0a6c1/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 160 USD, converted at ECB rate. Etsy tags: Rings for women,rings for men,natural stone,gift for her,jewellery making,jewellery supplies,jewellery findings,bicolour tourmaline,pink tourmaline,stud jewellery,tourmaline emerald,green tourmaline,cushion cut.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('70e02ba1-1ccf-4e64-821a-5f409f2f7a64', '5.50Cts, Lagoon Bicolour Tourmaline.', 'Gorgeous Mesmerising Bicolour Lagoon Natural Afghanistan Tourmaline 

More beautiful In real, One of a kind

5.30 Cts
10.5 x 9.5 x 7mm

unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 197, 1, 'loose_stone', 'Tourmaline', NULL, 5.5, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/70e02ba1-1ccf-4e64-821a-5f409f2f7a64/etsy-1.jpg","https://media.gemworkers.com/items/70e02ba1-1ccf-4e64-821a-5f409f2f7a64/etsy-2.jpg","https://media.gemworkers.com/items/70e02ba1-1ccf-4e64-821a-5f409f2f7a64/etsy-3.jpg","https://media.gemworkers.com/items/70e02ba1-1ccf-4e64-821a-5f409f2f7a64/etsy-4.jpg","https://media.gemworkers.com/items/70e02ba1-1ccf-4e64-821a-5f409f2f7a64/etsy-5.jpg","https://media.gemworkers.com/items/70e02ba1-1ccf-4e64-821a-5f409f2f7a64/etsy-6.jpg","https://media.gemworkers.com/items/70e02ba1-1ccf-4e64-821a-5f409f2f7a64/etsy-7.jpg","https://media.gemworkers.com/items/70e02ba1-1ccf-4e64-821a-5f409f2f7a64/etsy-8.jpg","https://media.gemworkers.com/items/70e02ba1-1ccf-4e64-821a-5f409f2f7a64/etsy-9.jpg","https://media.gemworkers.com/items/70e02ba1-1ccf-4e64-821a-5f409f2f7a64/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 220 USD, converted at ECB rate. Etsy tags: Jewellery Supplies,Jewellery Making,Gold Rings,Rings For Men,Rings For Women,y2k earrings stud,Gift For Her,Tourmaline Jewellery,Natural Stone,Stud Earrings,Jewellery Stud,bicolour Tourmaline,Lagoon tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('f2069c97-ecd0-4225-9f1f-8d278080f700', '2.5 Cts Watermelon Bicolour Afghan Tourmaline Pair', 'Gorgeous Mesmerising Natural Watermelon Bicolour Afghan Tourmaline pair

high lustre, Saturated Colour.

2.55 Cts
7 x 4.8 x 3.6mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 223, 1, 'loose_stone', 'Tourmaline', 'Watermelon', 2.5, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/f2069c97-ecd0-4225-9f1f-8d278080f700/etsy-1.jpg","https://media.gemworkers.com/items/f2069c97-ecd0-4225-9f1f-8d278080f700/etsy-2.jpg","https://media.gemworkers.com/items/f2069c97-ecd0-4225-9f1f-8d278080f700/etsy-3.jpg","https://media.gemworkers.com/items/f2069c97-ecd0-4225-9f1f-8d278080f700/etsy-4.jpg","https://media.gemworkers.com/items/f2069c97-ecd0-4225-9f1f-8d278080f700/etsy-5.jpg","https://media.gemworkers.com/items/f2069c97-ecd0-4225-9f1f-8d278080f700/etsy-6.jpg","https://media.gemworkers.com/items/f2069c97-ecd0-4225-9f1f-8d278080f700/etsy-7.jpg","https://media.gemworkers.com/items/f2069c97-ecd0-4225-9f1f-8d278080f700/etsy-8.jpg","https://media.gemworkers.com/items/f2069c97-ecd0-4225-9f1f-8d278080f700/etsy-9.jpg","https://media.gemworkers.com/items/f2069c97-ecd0-4225-9f1f-8d278080f700/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 250 USD, converted at ECB rate. Etsy tags: Tourmaline Rings,rings for women,rings for men,jewellery making,jewellery findings,gift for her,natural stone,Oceangemsminerals,apple green colour,Bicolour Tourmaline,Natural Bicolour,Unheated Tourmaline,Lipstick Tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('6f17cc6d-0333-41c3-b2ec-0e1883e92a6d', '36.15 Cts Natural Kunzite', 'Gorgeous lustrous Natural Kunzite Pear Shape

36.15 Cts
21.4 x 17.3 x 15.6mm

Pear Shape

loupe clean

lustre and brilliance', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 446, 1, 'loose_stone', 'Kunzite', NULL, 36.15, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/6f17cc6d-0333-41c3-b2ec-0e1883e92a6d/etsy-1.jpg","https://media.gemworkers.com/items/6f17cc6d-0333-41c3-b2ec-0e1883e92a6d/etsy-2.jpg","https://media.gemworkers.com/items/6f17cc6d-0333-41c3-b2ec-0e1883e92a6d/etsy-3.jpg","https://media.gemworkers.com/items/6f17cc6d-0333-41c3-b2ec-0e1883e92a6d/etsy-4.jpg","https://media.gemworkers.com/items/6f17cc6d-0333-41c3-b2ec-0e1883e92a6d/etsy-5.jpg","https://media.gemworkers.com/items/6f17cc6d-0333-41c3-b2ec-0e1883e92a6d/etsy-6.jpg","https://media.gemworkers.com/items/6f17cc6d-0333-41c3-b2ec-0e1883e92a6d/etsy-7.jpg","https://media.gemworkers.com/items/6f17cc6d-0333-41c3-b2ec-0e1883e92a6d/etsy-8.jpg","https://media.gemworkers.com/items/6f17cc6d-0333-41c3-b2ec-0e1883e92a6d/etsy-9.jpg","https://media.gemworkers.com/items/6f17cc6d-0333-41c3-b2ec-0e1883e92a6d/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 499 USD, converted at ECB rate. Etsy tags: Terminated Crystals,Jewellery Making,Aquamarine Specimen,Collectors,AquamarineCollection,Blue Aquamarine,Green Aquamarine,Gift For Her,Natural Stone,Kunzite Crystal,Heated Kunzite,Rough Kunzite,Kunzite Jewellery.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('3e63c91b-c16a-4f5a-829d-1091a2315a2f', '16.8 Cts Natural Kunzite', 'Gorgeous lustrous Natural Kunzite

16.80 Cts 
13.6 x 12.7 x 11.3mm

loupe clean

lustre and brilliance', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 188, 1, 'loose_stone', 'Kunzite', NULL, 16.8, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/3e63c91b-c16a-4f5a-829d-1091a2315a2f/etsy-1.jpg","https://media.gemworkers.com/items/3e63c91b-c16a-4f5a-829d-1091a2315a2f/etsy-2.jpg","https://media.gemworkers.com/items/3e63c91b-c16a-4f5a-829d-1091a2315a2f/etsy-3.jpg","https://media.gemworkers.com/items/3e63c91b-c16a-4f5a-829d-1091a2315a2f/etsy-4.jpg","https://media.gemworkers.com/items/3e63c91b-c16a-4f5a-829d-1091a2315a2f/etsy-5.jpg","https://media.gemworkers.com/items/3e63c91b-c16a-4f5a-829d-1091a2315a2f/etsy-6.jpg","https://media.gemworkers.com/items/3e63c91b-c16a-4f5a-829d-1091a2315a2f/etsy-7.jpg","https://media.gemworkers.com/items/3e63c91b-c16a-4f5a-829d-1091a2315a2f/etsy-8.jpg","https://media.gemworkers.com/items/3e63c91b-c16a-4f5a-829d-1091a2315a2f/etsy-9.jpg","https://media.gemworkers.com/items/3e63c91b-c16a-4f5a-829d-1091a2315a2f/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 210 USD, converted at ECB rate. Etsy tags: Terminated Crystals,Jewellery Making,Aquamarine Specimen,Collectors,AquamarineCollection,Blue Aquamarine,Green Aquamarine,Gift For Her,Natural Stone,Kunzite Crystal,Heated Kunzite,Rough Kunzite,Kunzite Jewellery.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('867654fe-a34f-471a-bd59-04069fa56586', '6.10 Cts, Natural Watermelon Bicolour Afghan Tourmaline Pairs', 'Gorgeous Mesmerising Natural Watermelon Bicolour Afghan Tourmaline pairs

high lustre, Saturated Colour.

6.10 carats 

Size:6.4mm to 6.8mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 447, 1, 'loose_stone', 'Tourmaline', 'Watermelon', 6.1, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/867654fe-a34f-471a-bd59-04069fa56586/etsy-1.jpg","https://media.gemworkers.com/items/867654fe-a34f-471a-bd59-04069fa56586/etsy-2.jpg","https://media.gemworkers.com/items/867654fe-a34f-471a-bd59-04069fa56586/etsy-3.jpg","https://media.gemworkers.com/items/867654fe-a34f-471a-bd59-04069fa56586/etsy-4.jpg","https://media.gemworkers.com/items/867654fe-a34f-471a-bd59-04069fa56586/etsy-5.jpg","https://media.gemworkers.com/items/867654fe-a34f-471a-bd59-04069fa56586/etsy-6.jpg","https://media.gemworkers.com/items/867654fe-a34f-471a-bd59-04069fa56586/etsy-7.jpg","https://media.gemworkers.com/items/867654fe-a34f-471a-bd59-04069fa56586/etsy-8.jpg","https://media.gemworkers.com/items/867654fe-a34f-471a-bd59-04069fa56586/etsy-9.jpg","https://media.gemworkers.com/items/867654fe-a34f-471a-bd59-04069fa56586/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 500 USD, converted at ECB rate. Etsy tags: Tourmaline Rings,rings for women,rings for men,jewellery making,jewellery findings,gift for her,natural stone,Oceangemsminerals,apple green colour,Bicolour Tourmaline,Natural Bicolour,Unheated Tourmaline,Lipstick Tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('56c47d4e-99bb-43e2-a285-c76e453f5945', '5 Cts, Natural Watermelon Bicolour Afghan Tourmaline Pairs', 'Gorgeous Mesmerising Natural Watermelon Bicolour Afghan Tourmaline pairs

high lustre, Saturated Colour.

5 carats 

Size:5.7mm to 7.5mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 357, 1, 'loose_stone', 'Tourmaline', 'Watermelon', 5, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/56c47d4e-99bb-43e2-a285-c76e453f5945/etsy-1.jpg","https://media.gemworkers.com/items/56c47d4e-99bb-43e2-a285-c76e453f5945/etsy-2.jpg","https://media.gemworkers.com/items/56c47d4e-99bb-43e2-a285-c76e453f5945/etsy-3.jpg","https://media.gemworkers.com/items/56c47d4e-99bb-43e2-a285-c76e453f5945/etsy-4.jpg","https://media.gemworkers.com/items/56c47d4e-99bb-43e2-a285-c76e453f5945/etsy-5.jpg","https://media.gemworkers.com/items/56c47d4e-99bb-43e2-a285-c76e453f5945/etsy-6.jpg","https://media.gemworkers.com/items/56c47d4e-99bb-43e2-a285-c76e453f5945/etsy-7.jpg","https://media.gemworkers.com/items/56c47d4e-99bb-43e2-a285-c76e453f5945/etsy-8.jpg","https://media.gemworkers.com/items/56c47d4e-99bb-43e2-a285-c76e453f5945/etsy-9.jpg","https://media.gemworkers.com/items/56c47d4e-99bb-43e2-a285-c76e453f5945/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 400 USD, converted at ECB rate. Etsy tags: Tourmaline Rings,rings for women,rings for men,jewellery making,jewellery findings,gift for her,natural stone,Oceangemsminerals,apple green colour,Bicolour Tourmaline,Natural Bicolour,Unheated Tourmaline,Lipstick Tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('ecd1501e-c8d5-488a-a25f-4baf50fb3970', '6.10 Cts, Natural Watermelon Bicolour Afghan Tourmaline Pairs', 'Gorgeous Mesmerising Natural Watermelon Bicolour Afghan Tourmaline pairs

high lustre, Saturated Colour.

6.10 carats 

Size:6.4mm to 6.8mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 402, 1, 'loose_stone', 'Tourmaline', 'Watermelon', 6.1, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/ecd1501e-c8d5-488a-a25f-4baf50fb3970/etsy-1.jpg","https://media.gemworkers.com/items/ecd1501e-c8d5-488a-a25f-4baf50fb3970/etsy-2.jpg","https://media.gemworkers.com/items/ecd1501e-c8d5-488a-a25f-4baf50fb3970/etsy-3.jpg","https://media.gemworkers.com/items/ecd1501e-c8d5-488a-a25f-4baf50fb3970/etsy-4.jpg","https://media.gemworkers.com/items/ecd1501e-c8d5-488a-a25f-4baf50fb3970/etsy-5.jpg","https://media.gemworkers.com/items/ecd1501e-c8d5-488a-a25f-4baf50fb3970/etsy-6.jpg","https://media.gemworkers.com/items/ecd1501e-c8d5-488a-a25f-4baf50fb3970/etsy-7.jpg","https://media.gemworkers.com/items/ecd1501e-c8d5-488a-a25f-4baf50fb3970/etsy-8.jpg","https://media.gemworkers.com/items/ecd1501e-c8d5-488a-a25f-4baf50fb3970/etsy-9.jpg","https://media.gemworkers.com/items/ecd1501e-c8d5-488a-a25f-4baf50fb3970/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 450 USD, converted at ECB rate. Etsy tags: Tourmaline Rings,rings for women,rings for men,jewellery making,jewellery findings,gift for her,natural stone,Oceangemsminerals,apple green colour,Bicolour Tourmaline,Natural Bicolour,Unheated Tourmaline,Lipstick Tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('58c773d0-de4c-46a4-adce-e03749a49756', '4.40 Cts Sky Blue Colour Tourmaline', 'Gorgeous Afghan Sky Blue Colour Beautiful Tourmaline 

One Of A Kind And Brilliance

4.40 Cts
9.5 x 9.4 x 6.7mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 246, 1, 'loose_stone', 'Tourmaline', NULL, 4.4, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/58c773d0-de4c-46a4-adce-e03749a49756/etsy-1.jpg","https://media.gemworkers.com/items/58c773d0-de4c-46a4-adce-e03749a49756/etsy-2.jpg","https://media.gemworkers.com/items/58c773d0-de4c-46a4-adce-e03749a49756/etsy-3.jpg","https://media.gemworkers.com/items/58c773d0-de4c-46a4-adce-e03749a49756/etsy-4.jpg","https://media.gemworkers.com/items/58c773d0-de4c-46a4-adce-e03749a49756/etsy-5.jpg","https://media.gemworkers.com/items/58c773d0-de4c-46a4-adce-e03749a49756/etsy-6.jpg","https://media.gemworkers.com/items/58c773d0-de4c-46a4-adce-e03749a49756/etsy-7.jpg","https://media.gemworkers.com/items/58c773d0-de4c-46a4-adce-e03749a49756/etsy-8.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 275 USD, converted at ECB rate. Etsy tags: Paraiba Tourmaline,Paraiba Colour,Lagoon Tourmaline,Bluegreen Tourmaline,Blue Tourmaline,Neon Blue Tourmaline,Tourmaline Jewellery,Jewellers,Lagoon Colour,Oceangemsminerals,Ink Blue Tourmaline,Wedding Rings,Sky Blue Tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('49e0ff6c-a936-4014-9f94-0af5d0bff95e', '36.35 Cts Natural Kunzite Lot', 'Gorgeous lustrous Natural Kunzite Lot

36.35 Cts
15.8 to 11.4mm

Triangle Shape

loupe clean

lustre and brilliance', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 446, 1, 'loose_stone', 'Kunzite', NULL, 36.35, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/49e0ff6c-a936-4014-9f94-0af5d0bff95e/etsy-1.jpg","https://media.gemworkers.com/items/49e0ff6c-a936-4014-9f94-0af5d0bff95e/etsy-2.jpg","https://media.gemworkers.com/items/49e0ff6c-a936-4014-9f94-0af5d0bff95e/etsy-3.jpg","https://media.gemworkers.com/items/49e0ff6c-a936-4014-9f94-0af5d0bff95e/etsy-4.jpg","https://media.gemworkers.com/items/49e0ff6c-a936-4014-9f94-0af5d0bff95e/etsy-5.jpg","https://media.gemworkers.com/items/49e0ff6c-a936-4014-9f94-0af5d0bff95e/etsy-6.jpg","https://media.gemworkers.com/items/49e0ff6c-a936-4014-9f94-0af5d0bff95e/etsy-7.jpg","https://media.gemworkers.com/items/49e0ff6c-a936-4014-9f94-0af5d0bff95e/etsy-8.jpg","https://media.gemworkers.com/items/49e0ff6c-a936-4014-9f94-0af5d0bff95e/etsy-9.jpg","https://media.gemworkers.com/items/49e0ff6c-a936-4014-9f94-0af5d0bff95e/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 499 USD, converted at ECB rate. Etsy tags: Terminated Crystals,Jewellery Making,Aquamarine Specimen,Collectors,AquamarineCollection,Blue Aquamarine,Green Aquamarine,Gift For Her,Natural Stone,Kunzite Crystal,Heated Kunzite,Rough Kunzite,Kunzite Jewellery.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('5413a13f-6439-4598-a2f7-712a75c93617', '5.50 Cts Sky Blue Colour Tourmaline', '5.50 Cts
10.2 x 10 x 7.2mm

This exquisite **5.50-carat Sky Blue Afghan Tourmaline** captivates with its serene, oceanic hues and masterful cushion cut, embodying the geological artistry of Afghanistan’s rugged landscapes. Mined from the gem-rich regions of Nuristan and Kunar, this stone reflects the nation’s reputation for producing tourmalines of unparalleled color diversity and brilliance.  

**Key Features:**  
1. **Mesmerizing Color:** The stone’s sky-blue tone evokes the tranquility of clear Afghan skies, a rare and sought-after hue in tourmalines. This shade is often associated with calmness and emotional balance, making it a cherished choice for both jewelry and holistic practices.  
2. **Cushion Cut Brilliance:** The cushion cut enhances the gem’s natural luminosity, allowing light to dance across its facets. This classic yet versatile cut highlights the stone’s transparency and depth, creating a harmonious balance between elegance and modernity.  
3. **Inclusions as Character:** While the stone is included, these natural imperfections add a unique fingerprint, testifying to its authentic, untreated origin. Inclusions in Afghan tourmalines are often seen as markers of their geological journey, offering a narrative of formation under intense pressure and heat.  
4. **Ethical Sourcing:** Originating from Afghanistan’s storied mines, this gemstone supports local mining communities while adhering to growing initiatives for sustainable practices.  

**Ideal for:**  
- **Jewelry Design:** Perfect for statement rings, pendants, or earrings, its sky-blue hue pairs beautifully with white gold or platinum settings.  
- **Collectors & Investors:** Afghan tourmalines are prized for their rarity, with values influenced by carat weight, color saturation, and cut quality. A 5.50-carat specimen like this represents both aesthetic and investment potential.  
- **Holistic Use:** Believed to resonate with the throat chakra, it is said to promote clarity in communication and emotional serenity.  

**Technical Details:**  
- **Weight:** 5.50 carats  
- **Cut:** Cushion (dimensions approximate to similar stones: ~10mm in length/width)  
- **Clarity:** Slightly Included (SI)  
- **Origin:** Afghanistan (Kunar/Nuristan mines)  
- **Treatment:** None  

**Market Value:**  
While precise pricing depends on market trends, Afghan sky-blue tourmalines of this size and quality typically range between **$500–$1,500 per carat**, with premium cuts and unique hues commanding higher valuations.  

A gemstone that bridges nature’s artistry and human craftsmanship, this tourmaline is a testament to Afghanistan’s geological legacy—ideal for those seeking beauty with a story.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 246, 1, 'loose_stone', 'Tourmaline', NULL, 5.5, 'ct', 'Afghanistan', '** Slightly Included (SI)', NULL, '["https://media.gemworkers.com/items/5413a13f-6439-4598-a2f7-712a75c93617/etsy-1.jpg","https://media.gemworkers.com/items/5413a13f-6439-4598-a2f7-712a75c93617/etsy-2.jpg","https://media.gemworkers.com/items/5413a13f-6439-4598-a2f7-712a75c93617/etsy-3.jpg","https://media.gemworkers.com/items/5413a13f-6439-4598-a2f7-712a75c93617/etsy-4.jpg","https://media.gemworkers.com/items/5413a13f-6439-4598-a2f7-712a75c93617/etsy-5.jpg","https://media.gemworkers.com/items/5413a13f-6439-4598-a2f7-712a75c93617/etsy-6.jpg","https://media.gemworkers.com/items/5413a13f-6439-4598-a2f7-712a75c93617/etsy-7.jpg","https://media.gemworkers.com/items/5413a13f-6439-4598-a2f7-712a75c93617/etsy-8.jpg","https://media.gemworkers.com/items/5413a13f-6439-4598-a2f7-712a75c93617/etsy-9.jpg","https://media.gemworkers.com/items/5413a13f-6439-4598-a2f7-712a75c93617/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 275 USD, converted at ECB rate. Etsy tags: Paraiba Tourmaline,Paraiba Colour,Lagoon Tourmaline,Bluegreen Tourmaline,Blue Tourmaline,Neon Blue Tourmaline,Tourmaline Jewellery,Jewellers,Lagoon Colour,Oceangemsminerals,Ink Blue Tourmaline,Wedding Rings,Sky Blue Tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('a805d580-1f5d-4638-8b35-a1c1489cf0fa', '9.8 Cts Sky Blue Colour Tourmaline', 'This exquisite gemstone is a stunning sky blue 9.80-carat tourmaline, radiating a serene and captivating hue reminiscent of a clear summer sky. With a smooth, polished surface that enhances its natural luminosity. Its vibrant blue tone is both soothing and eye-catching, making it a perfect centerpiece for high-end jewelry. The tourmaline''s impressive size and vivid color saturation ensure it stands out as a rare and luxurious gem, ideal for collectors or those seeking a unique statement piece. Whether set in a ring, pendant, or earrings, this sky blue tourmaline is a true testament to nature''s artistry.

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 437, 1, 'loose_stone', 'Tourmaline', NULL, 9.8, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/a805d580-1f5d-4638-8b35-a1c1489cf0fa/etsy-1.jpg","https://media.gemworkers.com/items/a805d580-1f5d-4638-8b35-a1c1489cf0fa/etsy-2.jpg","https://media.gemworkers.com/items/a805d580-1f5d-4638-8b35-a1c1489cf0fa/etsy-3.jpg","https://media.gemworkers.com/items/a805d580-1f5d-4638-8b35-a1c1489cf0fa/etsy-4.jpg","https://media.gemworkers.com/items/a805d580-1f5d-4638-8b35-a1c1489cf0fa/etsy-5.jpg","https://media.gemworkers.com/items/a805d580-1f5d-4638-8b35-a1c1489cf0fa/etsy-6.jpg","https://media.gemworkers.com/items/a805d580-1f5d-4638-8b35-a1c1489cf0fa/etsy-7.jpg","https://media.gemworkers.com/items/a805d580-1f5d-4638-8b35-a1c1489cf0fa/etsy-8.jpg","https://media.gemworkers.com/items/a805d580-1f5d-4638-8b35-a1c1489cf0fa/etsy-9.jpg","https://media.gemworkers.com/items/a805d580-1f5d-4638-8b35-a1c1489cf0fa/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 489 USD, converted at ECB rate. Etsy tags: Paraiba Tourmaline,Paraiba Colour,Lagoon Tourmaline,Bluegreen Tourmaline,Blue Tourmaline,Neon Blue Tourmaline,Tourmaline Jewellery,Jewellers,Lagoon Colour,Oceangemsminerals,Ink Blue Tourmaline,Wedding Rings,Sky Blue Tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('19275f5e-5ab3-4d3c-b795-30405c9d6280', '29.5 Cts Natural Kunzite', 'Gorgeous lustrous Natural Kunzite

29.50 Cts
19.9 x 14.5 x 11mm

loupe clean

lustre and brilliance', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 264, 1, 'loose_stone', 'Kunzite', NULL, 29.5, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/19275f5e-5ab3-4d3c-b795-30405c9d6280/etsy-1.jpg","https://media.gemworkers.com/items/19275f5e-5ab3-4d3c-b795-30405c9d6280/etsy-2.jpg","https://media.gemworkers.com/items/19275f5e-5ab3-4d3c-b795-30405c9d6280/etsy-3.jpg","https://media.gemworkers.com/items/19275f5e-5ab3-4d3c-b795-30405c9d6280/etsy-4.jpg","https://media.gemworkers.com/items/19275f5e-5ab3-4d3c-b795-30405c9d6280/etsy-5.jpg","https://media.gemworkers.com/items/19275f5e-5ab3-4d3c-b795-30405c9d6280/etsy-6.jpg","https://media.gemworkers.com/items/19275f5e-5ab3-4d3c-b795-30405c9d6280/etsy-7.jpg","https://media.gemworkers.com/items/19275f5e-5ab3-4d3c-b795-30405c9d6280/etsy-8.jpg","https://media.gemworkers.com/items/19275f5e-5ab3-4d3c-b795-30405c9d6280/etsy-9.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 295 USD, converted at ECB rate. Etsy tags: Terminated Crystals,Jewellery Making,Aquamarine Specimen,Collectors,AquamarineCollection,Blue Aquamarine,Green Aquamarine,Gift For Her,Natural Stone,Kunzite Crystal,Heated Kunzite,Rough Kunzite,Kunzite Jewellery.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('680fb221-e45b-4139-8c8b-e13174c7ae5b', '64.5 Cts Natural Kunzite Lot', 'Gorgeous lustrous Natural Kunzite Lot

64.55 Cts
19.8 to 10.6mm

loupe clean

lustre and brilliance', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 446, 1, 'loose_stone', 'Kunzite', NULL, 64.5, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/680fb221-e45b-4139-8c8b-e13174c7ae5b/etsy-1.jpg","https://media.gemworkers.com/items/680fb221-e45b-4139-8c8b-e13174c7ae5b/etsy-2.jpg","https://media.gemworkers.com/items/680fb221-e45b-4139-8c8b-e13174c7ae5b/etsy-3.jpg","https://media.gemworkers.com/items/680fb221-e45b-4139-8c8b-e13174c7ae5b/etsy-4.jpg","https://media.gemworkers.com/items/680fb221-e45b-4139-8c8b-e13174c7ae5b/etsy-5.jpg","https://media.gemworkers.com/items/680fb221-e45b-4139-8c8b-e13174c7ae5b/etsy-6.jpg","https://media.gemworkers.com/items/680fb221-e45b-4139-8c8b-e13174c7ae5b/etsy-7.jpg","https://media.gemworkers.com/items/680fb221-e45b-4139-8c8b-e13174c7ae5b/etsy-8.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 499 USD, converted at ECB rate. Etsy tags: Terminated Crystals,Jewellery Making,Aquamarine Specimen,Collectors,AquamarineCollection,Blue Aquamarine,Green Aquamarine,Gift For Her,Natural Stone,Kunzite Crystal,Heated Kunzite,Rough Kunzite,Kunzite Jewellery.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('250efe90-140e-4a56-885c-662a097f7cc9', '12.5 Cts Natural Kunzite', 'Gorgeous lustrous Natural Kunzite 

12.50 Cts
11.6 x 10.1 x 7.7mm
9 x 9 x 7mm', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 143, 1, 'loose_stone', 'Kunzite', NULL, 12.5, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/250efe90-140e-4a56-885c-662a097f7cc9/etsy-1.jpg","https://media.gemworkers.com/items/250efe90-140e-4a56-885c-662a097f7cc9/etsy-2.jpg","https://media.gemworkers.com/items/250efe90-140e-4a56-885c-662a097f7cc9/etsy-3.jpg","https://media.gemworkers.com/items/250efe90-140e-4a56-885c-662a097f7cc9/etsy-4.jpg","https://media.gemworkers.com/items/250efe90-140e-4a56-885c-662a097f7cc9/etsy-5.jpg","https://media.gemworkers.com/items/250efe90-140e-4a56-885c-662a097f7cc9/etsy-6.jpg","https://media.gemworkers.com/items/250efe90-140e-4a56-885c-662a097f7cc9/etsy-7.jpg","https://media.gemworkers.com/items/250efe90-140e-4a56-885c-662a097f7cc9/etsy-8.jpg","https://media.gemworkers.com/items/250efe90-140e-4a56-885c-662a097f7cc9/etsy-9.jpg","https://media.gemworkers.com/items/250efe90-140e-4a56-885c-662a097f7cc9/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 160 USD, converted at ECB rate. Etsy tags: Terminated Crystals,Jewellery Making,Aquamarine Specimen,Collectors,AquamarineCollection,Blue Aquamarine,Green Aquamarine,Gift For Her,Natural Stone,Kunzite Crystal,Heated Kunzite,Rough Kunzite,Kunzite Jewellery.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('edb9b77e-5ac9-4be0-bb67-144a92d61ccb', '1.30Cts, Lagoon Bicolour Tourmaline.', 'Gorgeous Mesmerising Bicolour Lagoon Green Natural Afghanistan Tourmaline 

More beautiful In real, One of a kind

almost eye clean

1.30 carats 
8 x 5 x 3.5mm

unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 143, 1, 'loose_stone', 'Tourmaline', NULL, 1.3, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/edb9b77e-5ac9-4be0-bb67-144a92d61ccb/etsy-1.jpg","https://media.gemworkers.com/items/edb9b77e-5ac9-4be0-bb67-144a92d61ccb/etsy-2.jpg","https://media.gemworkers.com/items/edb9b77e-5ac9-4be0-bb67-144a92d61ccb/etsy-3.jpg","https://media.gemworkers.com/items/edb9b77e-5ac9-4be0-bb67-144a92d61ccb/etsy-4.jpg","https://media.gemworkers.com/items/edb9b77e-5ac9-4be0-bb67-144a92d61ccb/etsy-5.jpg","https://media.gemworkers.com/items/edb9b77e-5ac9-4be0-bb67-144a92d61ccb/etsy-6.jpg","https://media.gemworkers.com/items/edb9b77e-5ac9-4be0-bb67-144a92d61ccb/etsy-7.jpg","https://media.gemworkers.com/items/edb9b77e-5ac9-4be0-bb67-144a92d61ccb/etsy-8.jpg","https://media.gemworkers.com/items/edb9b77e-5ac9-4be0-bb67-144a92d61ccb/etsy-9.jpg","https://media.gemworkers.com/items/edb9b77e-5ac9-4be0-bb67-144a92d61ccb/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 160 USD, converted at ECB rate. Etsy tags: Gold Rings,Rings For Men,Tourmaline Jewellery,Natural Stone,bicolour Tourmaline,Lagoon tourmaline,Bluegreen tourmaline,blue tourmaline,indicolite tourmalin,tourmaline rings,faceted tourmaline,Oceangemsminerals,tourmaline lot.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('8fab0f18-3785-4e5d-b1a4-8fa0c76a8616', '2.00 Cts Yellow Tourmaline', 'A Very Unique Sunset Bicolour Tourmaline 

Gorgeous, Lustre And Brilliance 

95% Clean

6.50 Cts
12.5 x 9.8 x 6.7mm

Unheated,Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 89, 1, 'loose_stone', 'Tourmaline', NULL, 2, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/8fab0f18-3785-4e5d-b1a4-8fa0c76a8616/etsy-1.jpg","https://media.gemworkers.com/items/8fab0f18-3785-4e5d-b1a4-8fa0c76a8616/etsy-2.jpg","https://media.gemworkers.com/items/8fab0f18-3785-4e5d-b1a4-8fa0c76a8616/etsy-3.jpg","https://media.gemworkers.com/items/8fab0f18-3785-4e5d-b1a4-8fa0c76a8616/etsy-4.jpg","https://media.gemworkers.com/items/8fab0f18-3785-4e5d-b1a4-8fa0c76a8616/etsy-5.jpg","https://media.gemworkers.com/items/8fab0f18-3785-4e5d-b1a4-8fa0c76a8616/etsy-6.jpg","https://media.gemworkers.com/items/8fab0f18-3785-4e5d-b1a4-8fa0c76a8616/etsy-7.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 100 USD, converted at ECB rate. Etsy tags: Sunset Tourmaline,Yellow Tourmaline,Bicolour Tourmaline,Brown Tourmaline,Tourmaline Rings,Bicolour Rings,Tourmaline Jewellery,Unique Bicolour,Unique Tourmaline,Rings For Men,Rings For Women,Handmade Jewellery,Jewellery Findings.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('c022e13d-3f65-4769-be11-bbbd1d298f02', '4.40 Cts Rubilite Tourmaline Set', 'Gorgeous Rubilite Tourmaline best for ring and earrings 

4.40 Cts
10.2 x 7.5 x 4.4mm
7.9 x 5.2 x 4.2nm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 179, 1, 'loose_stone', 'Tourmaline', 'Rubellite', 4.4, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/c022e13d-3f65-4769-be11-bbbd1d298f02/etsy-1.jpg","https://media.gemworkers.com/items/c022e13d-3f65-4769-be11-bbbd1d298f02/etsy-2.jpg","https://media.gemworkers.com/items/c022e13d-3f65-4769-be11-bbbd1d298f02/etsy-3.jpg","https://media.gemworkers.com/items/c022e13d-3f65-4769-be11-bbbd1d298f02/etsy-4.jpg","https://media.gemworkers.com/items/c022e13d-3f65-4769-be11-bbbd1d298f02/etsy-5.jpg","https://media.gemworkers.com/items/c022e13d-3f65-4769-be11-bbbd1d298f02/etsy-6.jpg","https://media.gemworkers.com/items/c022e13d-3f65-4769-be11-bbbd1d298f02/etsy-7.jpg","https://media.gemworkers.com/items/c022e13d-3f65-4769-be11-bbbd1d298f02/etsy-8.jpg","https://media.gemworkers.com/items/c022e13d-3f65-4769-be11-bbbd1d298f02/etsy-9.jpg","https://media.gemworkers.com/items/c022e13d-3f65-4769-be11-bbbd1d298f02/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 200 USD, converted at ECB rate. Etsy tags: Red Rubilite,PigeonBlood Rubilite,Orange Rubilite,Pinkish Rubilite,Red Tourmaline,Pink Tourmaline,Orange Tourmaline,Cushion Cut,Tourmaline Jewellery,Tourmaline Faceted,Rubilite Tourmaline,Jewellery Making,Jewellery Findings.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('7f3e4607-f3ef-455a-9b59-a921b347733c', '1.70 Cts Green Tourmaline', 'Green Tourmaline 

unique colour 

1.70 Cts
7 x 5.8 x 4.9mm

no treatment', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 116, 1, 'loose_stone', 'Tourmaline', NULL, 1.7, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/7f3e4607-f3ef-455a-9b59-a921b347733c/etsy-1.jpg","https://media.gemworkers.com/items/7f3e4607-f3ef-455a-9b59-a921b347733c/etsy-2.jpg","https://media.gemworkers.com/items/7f3e4607-f3ef-455a-9b59-a921b347733c/etsy-3.jpg","https://media.gemworkers.com/items/7f3e4607-f3ef-455a-9b59-a921b347733c/etsy-4.jpg","https://media.gemworkers.com/items/7f3e4607-f3ef-455a-9b59-a921b347733c/etsy-5.jpg","https://media.gemworkers.com/items/7f3e4607-f3ef-455a-9b59-a921b347733c/etsy-6.jpg","https://media.gemworkers.com/items/7f3e4607-f3ef-455a-9b59-a921b347733c/etsy-7.jpg","https://media.gemworkers.com/items/7f3e4607-f3ef-455a-9b59-a921b347733c/etsy-8.jpg","https://media.gemworkers.com/items/7f3e4607-f3ef-455a-9b59-a921b347733c/etsy-9.jpg","https://media.gemworkers.com/items/7f3e4607-f3ef-455a-9b59-a921b347733c/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 130 USD, converted at ECB rate. Etsy tags: Tourmaline Jewellery,Jewellery Making,Jewellery supplies,jewellery findings,Gold Rings,Rings For Women,Natural Stone,Handmade,Gift For Her,Green Tourmaline,Cushion Cut,Tourmaline Rings,Rings Supplies.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('d033604f-31f6-481f-a05d-f79cac86123c', '1.60 Cts Rubilite Tourmaline', 'Gorgeous Rubilite Tourmaline best for ring 💍 

1.60 Cts
7.2 x 6.3 x 4.7mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 107, 1, 'loose_stone', 'Tourmaline', 'Rubellite', 1.6, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/d033604f-31f6-481f-a05d-f79cac86123c/etsy-1.jpg","https://media.gemworkers.com/items/d033604f-31f6-481f-a05d-f79cac86123c/etsy-2.jpg","https://media.gemworkers.com/items/d033604f-31f6-481f-a05d-f79cac86123c/etsy-3.jpg","https://media.gemworkers.com/items/d033604f-31f6-481f-a05d-f79cac86123c/etsy-4.jpg","https://media.gemworkers.com/items/d033604f-31f6-481f-a05d-f79cac86123c/etsy-5.jpg","https://media.gemworkers.com/items/d033604f-31f6-481f-a05d-f79cac86123c/etsy-6.jpg","https://media.gemworkers.com/items/d033604f-31f6-481f-a05d-f79cac86123c/etsy-7.jpg","https://media.gemworkers.com/items/d033604f-31f6-481f-a05d-f79cac86123c/etsy-8.jpg","https://media.gemworkers.com/items/d033604f-31f6-481f-a05d-f79cac86123c/etsy-9.jpg","https://media.gemworkers.com/items/d033604f-31f6-481f-a05d-f79cac86123c/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 120 USD, converted at ECB rate. Etsy tags: Red Rubilite,PigeonBlood Rubilite,Orange Rubilite,Pinkish Rubilite,Red Tourmaline,Pink Tourmaline,Orange Tourmaline,Cushion Cut,Tourmaline Jewellery,Tourmaline Faceted,Rubilite Tourmaline,Jewellery Making,Jewellery Findings.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('53737824-fcc0-4623-bdaa-ade5baddcbcc', '2.70 Cts Honey Colour Tourmaline', 'Honey Colour Tourmaline 

unique colour 

2.70 Cts
8.8 x 6.5 x 5.7mm

no treatment', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 161, 1, 'loose_stone', 'Tourmaline', NULL, 2.7, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/53737824-fcc0-4623-bdaa-ade5baddcbcc/etsy-1.jpg","https://media.gemworkers.com/items/53737824-fcc0-4623-bdaa-ade5baddcbcc/etsy-2.jpg","https://media.gemworkers.com/items/53737824-fcc0-4623-bdaa-ade5baddcbcc/etsy-3.jpg","https://media.gemworkers.com/items/53737824-fcc0-4623-bdaa-ade5baddcbcc/etsy-4.jpg","https://media.gemworkers.com/items/53737824-fcc0-4623-bdaa-ade5baddcbcc/etsy-5.jpg","https://media.gemworkers.com/items/53737824-fcc0-4623-bdaa-ade5baddcbcc/etsy-6.jpg","https://media.gemworkers.com/items/53737824-fcc0-4623-bdaa-ade5baddcbcc/etsy-7.jpg","https://media.gemworkers.com/items/53737824-fcc0-4623-bdaa-ade5baddcbcc/etsy-8.jpg","https://media.gemworkers.com/items/53737824-fcc0-4623-bdaa-ade5baddcbcc/etsy-9.jpg","https://media.gemworkers.com/items/53737824-fcc0-4623-bdaa-ade5baddcbcc/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 180 USD, converted at ECB rate. Etsy tags: Tourmaline Jewellery,Jewellery Making,Jewellery supplies,jewellery findings,Gold Rings,Rings For Women,Natural Stone,Handmade,Gift For Her,Green Tourmaline,Cushion Cut,Tourmaline Rings,Rings Supplies.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('9095f948-fedd-4c76-886d-e08509b9ad04', '1.60 Cts Green Tourmaline', 'Green Tourmaline 

unique colour 

1.60 Cts
7.5 x 6.2 x 4.3mm

no treatment', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 107, 1, 'loose_stone', 'Tourmaline', NULL, 1.6, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/9095f948-fedd-4c76-886d-e08509b9ad04/etsy-1.jpg","https://media.gemworkers.com/items/9095f948-fedd-4c76-886d-e08509b9ad04/etsy-2.jpg","https://media.gemworkers.com/items/9095f948-fedd-4c76-886d-e08509b9ad04/etsy-3.jpg","https://media.gemworkers.com/items/9095f948-fedd-4c76-886d-e08509b9ad04/etsy-4.jpg","https://media.gemworkers.com/items/9095f948-fedd-4c76-886d-e08509b9ad04/etsy-5.jpg","https://media.gemworkers.com/items/9095f948-fedd-4c76-886d-e08509b9ad04/etsy-6.jpg","https://media.gemworkers.com/items/9095f948-fedd-4c76-886d-e08509b9ad04/etsy-7.jpg","https://media.gemworkers.com/items/9095f948-fedd-4c76-886d-e08509b9ad04/etsy-8.jpg","https://media.gemworkers.com/items/9095f948-fedd-4c76-886d-e08509b9ad04/etsy-9.jpg","https://media.gemworkers.com/items/9095f948-fedd-4c76-886d-e08509b9ad04/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 120 USD, converted at ECB rate. Etsy tags: Tourmaline Jewellery,Jewellery Making,Jewellery supplies,jewellery findings,Gold Rings,Rings For Women,Natural Stone,Handmade,Gift For Her,Green Tourmaline,Cushion Cut,Tourmaline Rings,Rings Supplies.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('455e899b-a6d7-48c3-a197-b160172d05bc', '2.00 Cts Green Tourmaline', 'Green Tourmaline 

unique colour 

2.00 Cts
8.1 x 6.5 x 4.8mm

no treatment', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 268, 1, 'loose_stone', 'Tourmaline', NULL, 2, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/455e899b-a6d7-48c3-a197-b160172d05bc/etsy-1.jpg","https://media.gemworkers.com/items/455e899b-a6d7-48c3-a197-b160172d05bc/etsy-2.jpg","https://media.gemworkers.com/items/455e899b-a6d7-48c3-a197-b160172d05bc/etsy-3.jpg","https://media.gemworkers.com/items/455e899b-a6d7-48c3-a197-b160172d05bc/etsy-4.jpg","https://media.gemworkers.com/items/455e899b-a6d7-48c3-a197-b160172d05bc/etsy-5.jpg","https://media.gemworkers.com/items/455e899b-a6d7-48c3-a197-b160172d05bc/etsy-6.jpg","https://media.gemworkers.com/items/455e899b-a6d7-48c3-a197-b160172d05bc/etsy-7.jpg","https://media.gemworkers.com/items/455e899b-a6d7-48c3-a197-b160172d05bc/etsy-8.jpg","https://media.gemworkers.com/items/455e899b-a6d7-48c3-a197-b160172d05bc/etsy-9.jpg","https://media.gemworkers.com/items/455e899b-a6d7-48c3-a197-b160172d05bc/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 300 USD, converted at ECB rate. Etsy tags: Tourmaline Jewellery,Jewellery Making,Jewellery supplies,jewellery findings,Gold Rings,Rings For Women,Natural Stone,Handmade,Gift For Her,Green Tourmaline,Cushion Cut,Tourmaline Rings,Rings Supplies.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('f8c0bc6a-caca-48a0-b5d3-3a6eb8e1eadd', '2.05 Cts Green Tourmaline', 'Green Tourmaline 

unique colour 

2.05 Cts
9.4 x 5.6 x 4.3mm

no treatment', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 268, 1, 'loose_stone', 'Tourmaline', NULL, 2.05, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/f8c0bc6a-caca-48a0-b5d3-3a6eb8e1eadd/etsy-1.jpg","https://media.gemworkers.com/items/f8c0bc6a-caca-48a0-b5d3-3a6eb8e1eadd/etsy-2.jpg","https://media.gemworkers.com/items/f8c0bc6a-caca-48a0-b5d3-3a6eb8e1eadd/etsy-3.jpg","https://media.gemworkers.com/items/f8c0bc6a-caca-48a0-b5d3-3a6eb8e1eadd/etsy-4.jpg","https://media.gemworkers.com/items/f8c0bc6a-caca-48a0-b5d3-3a6eb8e1eadd/etsy-5.jpg","https://media.gemworkers.com/items/f8c0bc6a-caca-48a0-b5d3-3a6eb8e1eadd/etsy-6.jpg","https://media.gemworkers.com/items/f8c0bc6a-caca-48a0-b5d3-3a6eb8e1eadd/etsy-7.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 300 USD, converted at ECB rate. Etsy tags: Tourmaline Jewellery,Jewellery Making,Jewellery supplies,jewellery findings,Gold Rings,Rings For Women,Natural Stone,Handmade,Gift For Her,Green Tourmaline,Cushion Cut,Tourmaline Rings,Rings Supplies.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('1d5f9528-b9cf-4c9e-b633-b82a2ef03ff5', '5.10 Cts Green Tourmaline', 'Green Tourmaline 

unique colour 

5.10 Cts
13.4 x 7.4 x 5.3mm

no treatment', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 313, 1, 'loose_stone', 'Tourmaline', NULL, 5.1, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/1d5f9528-b9cf-4c9e-b633-b82a2ef03ff5/etsy-1.jpg","https://media.gemworkers.com/items/1d5f9528-b9cf-4c9e-b633-b82a2ef03ff5/etsy-2.jpg","https://media.gemworkers.com/items/1d5f9528-b9cf-4c9e-b633-b82a2ef03ff5/etsy-3.jpg","https://media.gemworkers.com/items/1d5f9528-b9cf-4c9e-b633-b82a2ef03ff5/etsy-4.jpg","https://media.gemworkers.com/items/1d5f9528-b9cf-4c9e-b633-b82a2ef03ff5/etsy-5.jpg","https://media.gemworkers.com/items/1d5f9528-b9cf-4c9e-b633-b82a2ef03ff5/etsy-6.jpg","https://media.gemworkers.com/items/1d5f9528-b9cf-4c9e-b633-b82a2ef03ff5/etsy-7.jpg","https://media.gemworkers.com/items/1d5f9528-b9cf-4c9e-b633-b82a2ef03ff5/etsy-8.jpg","https://media.gemworkers.com/items/1d5f9528-b9cf-4c9e-b633-b82a2ef03ff5/etsy-9.jpg","https://media.gemworkers.com/items/1d5f9528-b9cf-4c9e-b633-b82a2ef03ff5/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 350 USD, converted at ECB rate. Etsy tags: Tourmaline Jewellery,Jewellery Making,Jewellery supplies,jewellery findings,Gold Rings,Rings For Women,Natural Stone,Handmade,Gift For Her,Green Tourmaline,Cushion Cut,Tourmaline Rings,Rings Supplies.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('f1f11207-2597-4a3f-8a4b-7b2a4f41bc61', '2.55 Cts Chrome Green Tourmaline', 'Gorgeous Mesmerising Chrome Green Cool Colour Afghan Tourmaline Pair

Mimicking tsavorite garnet

One Of A Kind

2.55 Cts
6.3 x 5.3 x 4.6mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 313, 1, 'loose_stone', 'Tourmaline', NULL, 2.55, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/f1f11207-2597-4a3f-8a4b-7b2a4f41bc61/etsy-1.jpg","https://media.gemworkers.com/items/f1f11207-2597-4a3f-8a4b-7b2a4f41bc61/etsy-2.jpg","https://media.gemworkers.com/items/f1f11207-2597-4a3f-8a4b-7b2a4f41bc61/etsy-3.jpg","https://media.gemworkers.com/items/f1f11207-2597-4a3f-8a4b-7b2a4f41bc61/etsy-4.jpg","https://media.gemworkers.com/items/f1f11207-2597-4a3f-8a4b-7b2a4f41bc61/etsy-5.jpg","https://media.gemworkers.com/items/f1f11207-2597-4a3f-8a4b-7b2a4f41bc61/etsy-6.jpg","https://media.gemworkers.com/items/f1f11207-2597-4a3f-8a4b-7b2a4f41bc61/etsy-7.jpg","https://media.gemworkers.com/items/f1f11207-2597-4a3f-8a4b-7b2a4f41bc61/etsy-8.jpg","https://media.gemworkers.com/items/f1f11207-2597-4a3f-8a4b-7b2a4f41bc61/etsy-9.jpg","https://media.gemworkers.com/items/f1f11207-2597-4a3f-8a4b-7b2a4f41bc61/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 350 USD, converted at ECB rate. Etsy tags: Tourmaline Jewellery,Jewellery Supplies,Jewellery Making,Jewellery Findings,Tourmaline Earrings,Earrings Stud,y2k earrings stud,Gold Rings,Natural Stone,Gift For Her,Rings For Men,Rings For Women,Chrome Tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('3efb6332-d942-4f71-86cf-0717684b9a63', '3.60 Cts Green Colour Tourmaline', 'Unique Green Colour Afghan Tourmaline 

Brilliance And Lustre 

Ethically sourced  

3.60 Cts
9.8 x 7.1 x 6.1mm

Unheated, Untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 161, 1, 'loose_stone', 'Tourmaline', NULL, 3.6, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/3efb6332-d942-4f71-86cf-0717684b9a63/etsy-1.jpg","https://media.gemworkers.com/items/3efb6332-d942-4f71-86cf-0717684b9a63/etsy-2.jpg","https://media.gemworkers.com/items/3efb6332-d942-4f71-86cf-0717684b9a63/etsy-3.jpg","https://media.gemworkers.com/items/3efb6332-d942-4f71-86cf-0717684b9a63/etsy-4.jpg","https://media.gemworkers.com/items/3efb6332-d942-4f71-86cf-0717684b9a63/etsy-5.jpg","https://media.gemworkers.com/items/3efb6332-d942-4f71-86cf-0717684b9a63/etsy-6.jpg","https://media.gemworkers.com/items/3efb6332-d942-4f71-86cf-0717684b9a63/etsy-7.jpg","https://media.gemworkers.com/items/3efb6332-d942-4f71-86cf-0717684b9a63/etsy-8.jpg","https://media.gemworkers.com/items/3efb6332-d942-4f71-86cf-0717684b9a63/etsy-9.jpg","https://media.gemworkers.com/items/3efb6332-d942-4f71-86cf-0717684b9a63/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 180 USD, converted at ECB rate. Etsy tags: Jewellery Making,Jewellery Findings,Jewellery Supplies,Gold Rings,Gift For Her,Rings For Women,Rings For Men,Tourmaline Jewellery,Tourmaline Ring,Green Tourmaline,Tourmaline Supplies,Tourmaline Earrings,y2k earrings stud.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('963e5fe8-79ad-490d-ad94-bf8aee227b82', '8.90 Cts Green And Bicolour Tourmaline.', 'Gorgeous Mesmerising Bicolour and Green Natural Afghanistan Tourmaline 

More beautiful In real, One of a kind

8.90 Cts
12 x 8.4 x 5.8mm
9 x 7.4 x 6.2mm

unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 223, 1, 'loose_stone', 'Tourmaline', NULL, 8.9, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/963e5fe8-79ad-490d-ad94-bf8aee227b82/etsy-1.jpg","https://media.gemworkers.com/items/963e5fe8-79ad-490d-ad94-bf8aee227b82/etsy-2.jpg","https://media.gemworkers.com/items/963e5fe8-79ad-490d-ad94-bf8aee227b82/etsy-3.jpg","https://media.gemworkers.com/items/963e5fe8-79ad-490d-ad94-bf8aee227b82/etsy-4.jpg","https://media.gemworkers.com/items/963e5fe8-79ad-490d-ad94-bf8aee227b82/etsy-5.jpg","https://media.gemworkers.com/items/963e5fe8-79ad-490d-ad94-bf8aee227b82/etsy-6.jpg","https://media.gemworkers.com/items/963e5fe8-79ad-490d-ad94-bf8aee227b82/etsy-7.jpg","https://media.gemworkers.com/items/963e5fe8-79ad-490d-ad94-bf8aee227b82/etsy-8.jpg","https://media.gemworkers.com/items/963e5fe8-79ad-490d-ad94-bf8aee227b82/etsy-9.jpg","https://media.gemworkers.com/items/963e5fe8-79ad-490d-ad94-bf8aee227b82/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 250 USD, converted at ECB rate. Etsy tags: Gold Rings,Rings For Men,Tourmaline Jewellery,Natural Stone,bicolour Tourmaline,Lagoon tourmaline,Bluegreen tourmaline,blue tourmaline,indicolite tourmalin,tourmaline rings,faceted tourmaline,Oceangemsminerals,tourmaline lot.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('e6021aa4-4d17-421c-bd80-db89aa42f8bb', '2.85 Cts Bicolour Tourmaline', 'Natural bicolour mesmerising tourmaline 

2.85 Cts
8 x 7 x 5.2mm

unheated,', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 116, 1, 'loose_stone', 'Tourmaline', NULL, 2.85, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/e6021aa4-4d17-421c-bd80-db89aa42f8bb/etsy-1.jpg","https://media.gemworkers.com/items/e6021aa4-4d17-421c-bd80-db89aa42f8bb/etsy-2.jpg","https://media.gemworkers.com/items/e6021aa4-4d17-421c-bd80-db89aa42f8bb/etsy-3.jpg","https://media.gemworkers.com/items/e6021aa4-4d17-421c-bd80-db89aa42f8bb/etsy-4.jpg","https://media.gemworkers.com/items/e6021aa4-4d17-421c-bd80-db89aa42f8bb/etsy-5.jpg","https://media.gemworkers.com/items/e6021aa4-4d17-421c-bd80-db89aa42f8bb/etsy-6.jpg","https://media.gemworkers.com/items/e6021aa4-4d17-421c-bd80-db89aa42f8bb/etsy-7.jpg","https://media.gemworkers.com/items/e6021aa4-4d17-421c-bd80-db89aa42f8bb/etsy-8.jpg","https://media.gemworkers.com/items/e6021aa4-4d17-421c-bd80-db89aa42f8bb/etsy-9.jpg","https://media.gemworkers.com/items/e6021aa4-4d17-421c-bd80-db89aa42f8bb/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 130 USD, converted at ECB rate. Etsy tags: Rings for women,rings for men,natural stone,gift for her,jewellery making,jewellery supplies,jewellery findings,bicolour tourmaline,pink tourmaline,stud jewellery,tourmaline emerald,emerald cut,green tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('90a1f234-8272-4651-81fa-c28dd5e410e8', 'Watermelon Tourmaline Gemstones: Rare Color, High Lustre, Sugar Inclusions (28.85 Cts)', 'Sweet Perfect Watermelon Tourmaline 

Unique And Rare Colour

Very Shiny And High Lustre

Sugar Inclusions Gives It More Beauty 

28.85 Cts
21 x 13.5 x 10.9mm

No treatment.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 1786, 1, 'loose_stone', 'Tourmaline', 'Watermelon', 28.85, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/90a1f234-8272-4651-81fa-c28dd5e410e8/etsy-1.jpg","https://media.gemworkers.com/items/90a1f234-8272-4651-81fa-c28dd5e410e8/etsy-2.jpg","https://media.gemworkers.com/items/90a1f234-8272-4651-81fa-c28dd5e410e8/etsy-3.jpg","https://media.gemworkers.com/items/90a1f234-8272-4651-81fa-c28dd5e410e8/etsy-4.jpg","https://media.gemworkers.com/items/90a1f234-8272-4651-81fa-c28dd5e410e8/etsy-5.jpg","https://media.gemworkers.com/items/90a1f234-8272-4651-81fa-c28dd5e410e8/etsy-6.jpg","https://media.gemworkers.com/items/90a1f234-8272-4651-81fa-c28dd5e410e8/etsy-7.jpg","https://media.gemworkers.com/items/90a1f234-8272-4651-81fa-c28dd5e410e8/etsy-8.jpg","https://media.gemworkers.com/items/90a1f234-8272-4651-81fa-c28dd5e410e8/etsy-9.jpg","https://media.gemworkers.com/items/90a1f234-8272-4651-81fa-c28dd5e410e8/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 1999 USD, converted at ECB rate. Etsy tags: Tourmaline Jewellery,Tourmaline Earrings,Earrings Stud,y2k earrings stud,Gold Rings,Natural Stone,Gift For Her,Rings For Men,Oceangemsminerals,lagoon tourmaline,tourmaline pairs,bicolour tourmaline,Watermelon Bicolour.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('b1494d39-1bb3-4744-8cd9-8106a1af0821', '1.1 Cts Pink Tourmaline', 'Gorgeous Pink Tourmaline best for ring 💍 

1.10 Cts
6 x 5 x 4.8mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 134, 1, 'loose_stone', 'Tourmaline', NULL, 1.1, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/b1494d39-1bb3-4744-8cd9-8106a1af0821/etsy-1.jpg","https://media.gemworkers.com/items/b1494d39-1bb3-4744-8cd9-8106a1af0821/etsy-2.jpg","https://media.gemworkers.com/items/b1494d39-1bb3-4744-8cd9-8106a1af0821/etsy-3.jpg","https://media.gemworkers.com/items/b1494d39-1bb3-4744-8cd9-8106a1af0821/etsy-4.jpg","https://media.gemworkers.com/items/b1494d39-1bb3-4744-8cd9-8106a1af0821/etsy-5.jpg","https://media.gemworkers.com/items/b1494d39-1bb3-4744-8cd9-8106a1af0821/etsy-6.jpg","https://media.gemworkers.com/items/b1494d39-1bb3-4744-8cd9-8106a1af0821/etsy-7.jpg","https://media.gemworkers.com/items/b1494d39-1bb3-4744-8cd9-8106a1af0821/etsy-8.jpg","https://media.gemworkers.com/items/b1494d39-1bb3-4744-8cd9-8106a1af0821/etsy-9.jpg","https://media.gemworkers.com/items/b1494d39-1bb3-4744-8cd9-8106a1af0821/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 150 USD, converted at ECB rate. Etsy tags: Red Rubilite,PigeonBlood Rubilite,Orange Rubilite,Pinkish Rubilite,Red Tourmaline,Pink Tourmaline,Orange Tourmaline,Cushion Cut,Tourmaline Jewellery,Tourmaline Faceted,Rubilite Tourmaline,Jewellery Making,Jewellery Findings.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('fad3e5e2-6890-4fc1-b91e-28a013294445', '5.3 Cts Tricolour Tourmalines', 'Gorgeous TriColour Tourmalines

Exceptional And Unique 

5.35 Cts
Size10mm to 11.3mm

no treatment whatsoever', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 134, 1, 'loose_stone', 'Tourmaline', NULL, 5.3, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/fad3e5e2-6890-4fc1-b91e-28a013294445/etsy-1.jpg","https://media.gemworkers.com/items/fad3e5e2-6890-4fc1-b91e-28a013294445/etsy-2.jpg","https://media.gemworkers.com/items/fad3e5e2-6890-4fc1-b91e-28a013294445/etsy-3.jpg","https://media.gemworkers.com/items/fad3e5e2-6890-4fc1-b91e-28a013294445/etsy-4.jpg","https://media.gemworkers.com/items/fad3e5e2-6890-4fc1-b91e-28a013294445/etsy-5.jpg","https://media.gemworkers.com/items/fad3e5e2-6890-4fc1-b91e-28a013294445/etsy-6.jpg","https://media.gemworkers.com/items/fad3e5e2-6890-4fc1-b91e-28a013294445/etsy-7.jpg","https://media.gemworkers.com/items/fad3e5e2-6890-4fc1-b91e-28a013294445/etsy-8.jpg","https://media.gemworkers.com/items/fad3e5e2-6890-4fc1-b91e-28a013294445/etsy-9.jpg","https://media.gemworkers.com/items/fad3e5e2-6890-4fc1-b91e-28a013294445/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 150 USD, converted at ECB rate. Etsy tags: Tourmaline Jewellery,Tourmaline Rings,Natural Stone,Bicolour Tourmaline,Loose gemstones,Gold Rings,Rings For women,Rings For Men,y2k earrings stud,bicolour stone,Oceangemsminerals,Tricolour Tourmaline,Tourmaline Pairs.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('0362113d-d244-4869-bc4c-8cdf99a4b91e', '8.70 Cts Seafoam Tourmalines', 'Unique Natural Afghan Tourmalines

Bright and lustre

8.70 Cts
26.5 to 8mm 

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 223, 1, 'loose_stone', 'Tourmaline', NULL, 8.7, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/0362113d-d244-4869-bc4c-8cdf99a4b91e/etsy-1.jpg","https://media.gemworkers.com/items/0362113d-d244-4869-bc4c-8cdf99a4b91e/etsy-2.jpg","https://media.gemworkers.com/items/0362113d-d244-4869-bc4c-8cdf99a4b91e/etsy-3.jpg","https://media.gemworkers.com/items/0362113d-d244-4869-bc4c-8cdf99a4b91e/etsy-4.jpg","https://media.gemworkers.com/items/0362113d-d244-4869-bc4c-8cdf99a4b91e/etsy-5.jpg","https://media.gemworkers.com/items/0362113d-d244-4869-bc4c-8cdf99a4b91e/etsy-6.jpg","https://media.gemworkers.com/items/0362113d-d244-4869-bc4c-8cdf99a4b91e/etsy-7.jpg","https://media.gemworkers.com/items/0362113d-d244-4869-bc4c-8cdf99a4b91e/etsy-8.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 250 USD, converted at ECB rate. Etsy tags: Paraiba Tourmaline,Paraiba Colour,Lagoon Tourmaline,Bluegreen Tourmaline,Blue Tourmaline,Neon Blue Tourmaline,Tourmaline Jewellery,Jewellers,Lagoon Colour,Oceangemsminerals,Ink Blue Tourmaline,Wedding Rings,Rings For Women.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('1fc8f6ee-c509-41b4-9c5c-a76243c3a60a', '9.2 Cts Lagoon Tourmaline lot', 'Lagoon tourmaline lot 

Bright colour 

More Beautiful In Real And At very reasonable price 

9.20 Cts
4.9 to 6.2mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 313, 1, 'loose_stone', 'Tourmaline', NULL, 9.2, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/1fc8f6ee-c509-41b4-9c5c-a76243c3a60a/etsy-1.jpg","https://media.gemworkers.com/items/1fc8f6ee-c509-41b4-9c5c-a76243c3a60a/etsy-2.jpg","https://media.gemworkers.com/items/1fc8f6ee-c509-41b4-9c5c-a76243c3a60a/etsy-3.jpg","https://media.gemworkers.com/items/1fc8f6ee-c509-41b4-9c5c-a76243c3a60a/etsy-4.jpg","https://media.gemworkers.com/items/1fc8f6ee-c509-41b4-9c5c-a76243c3a60a/etsy-5.jpg","https://media.gemworkers.com/items/1fc8f6ee-c509-41b4-9c5c-a76243c3a60a/etsy-6.jpg","https://media.gemworkers.com/items/1fc8f6ee-c509-41b4-9c5c-a76243c3a60a/etsy-7.jpg","https://media.gemworkers.com/items/1fc8f6ee-c509-41b4-9c5c-a76243c3a60a/etsy-8.jpg","https://media.gemworkers.com/items/1fc8f6ee-c509-41b4-9c5c-a76243c3a60a/etsy-9.jpg","https://media.gemworkers.com/items/1fc8f6ee-c509-41b4-9c5c-a76243c3a60a/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 350 USD, converted at ECB rate. Etsy tags: Paraiba Tourmaline,Paraiba Colour,Lagoon Tourmaline,Bluegreen Tourmaline,Blue Tourmaline,Neon Blue Tourmaline,Tourmaline Jewellery,Jewellers,Lagoon Colour,Oceangemsminerals,Ink Blue Tourmaline,Rings For Women,bicolour tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('bfeb9e0a-c99b-4654-adf4-10d183c590bb', '8.2 Cts Green Tourmaline Lot', 'Cushion Cut Afghan Tourmaline Lot

Hugh Lustre

8.2 Cts
5 to 8.7mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 250, 1, 'loose_stone', 'Tourmaline', NULL, 8.2, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/bfeb9e0a-c99b-4654-adf4-10d183c590bb/etsy-1.jpg","https://media.gemworkers.com/items/bfeb9e0a-c99b-4654-adf4-10d183c590bb/etsy-2.jpg","https://media.gemworkers.com/items/bfeb9e0a-c99b-4654-adf4-10d183c590bb/etsy-3.jpg","https://media.gemworkers.com/items/bfeb9e0a-c99b-4654-adf4-10d183c590bb/etsy-4.jpg","https://media.gemworkers.com/items/bfeb9e0a-c99b-4654-adf4-10d183c590bb/etsy-5.jpg","https://media.gemworkers.com/items/bfeb9e0a-c99b-4654-adf4-10d183c590bb/etsy-6.jpg","https://media.gemworkers.com/items/bfeb9e0a-c99b-4654-adf4-10d183c590bb/etsy-7.jpg","https://media.gemworkers.com/items/bfeb9e0a-c99b-4654-adf4-10d183c590bb/etsy-8.jpg","https://media.gemworkers.com/items/bfeb9e0a-c99b-4654-adf4-10d183c590bb/etsy-9.jpg","https://media.gemworkers.com/items/bfeb9e0a-c99b-4654-adf4-10d183c590bb/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 280 USD, converted at ECB rate. Etsy tags: Paraiba Tourmaline,Paraiba Colour,Lagoon Tourmaline,Bluegreen Tourmaline,Blue Tourmaline,Neon Blue Tourmaline,Tourmaline Jewellery,Lagoon Colour,Oceangemsminerals,Ink Blue Tourmaline,Wedding Rings,Rings For Women,Cushion Cut.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('27767c2f-dd5f-4cd7-a296-743af1d6eed5', '6.7 Cts Lagoon Tourmaline lot', 'Lagoon tourmaline lot 

Bright colour 

More Beautiful In Real And At very reasonable price 

6.7 Cts
4.8 to 7.8mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 178, 1, 'loose_stone', 'Tourmaline', NULL, 6.7, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/27767c2f-dd5f-4cd7-a296-743af1d6eed5/etsy-1.jpg","https://media.gemworkers.com/items/27767c2f-dd5f-4cd7-a296-743af1d6eed5/etsy-2.jpg","https://media.gemworkers.com/items/27767c2f-dd5f-4cd7-a296-743af1d6eed5/etsy-3.jpg","https://media.gemworkers.com/items/27767c2f-dd5f-4cd7-a296-743af1d6eed5/etsy-4.jpg","https://media.gemworkers.com/items/27767c2f-dd5f-4cd7-a296-743af1d6eed5/etsy-5.jpg","https://media.gemworkers.com/items/27767c2f-dd5f-4cd7-a296-743af1d6eed5/etsy-6.jpg","https://media.gemworkers.com/items/27767c2f-dd5f-4cd7-a296-743af1d6eed5/etsy-7.jpg","https://media.gemworkers.com/items/27767c2f-dd5f-4cd7-a296-743af1d6eed5/etsy-8.jpg","https://media.gemworkers.com/items/27767c2f-dd5f-4cd7-a296-743af1d6eed5/etsy-9.jpg","https://media.gemworkers.com/items/27767c2f-dd5f-4cd7-a296-743af1d6eed5/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 199 USD, converted at ECB rate. Etsy tags: Paraiba Tourmaline,Paraiba Colour,Lagoon Tourmaline,Bluegreen Tourmaline,Blue Tourmaline,Neon Blue Tourmaline,Tourmaline Jewellery,Jewellers,Lagoon Colour,Oceangemsminerals,Ink Blue Tourmaline,Rings For Women,bicolour tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('ce23b8d2-5be0-48d6-a4c2-e7c29feef131', '5.45 Cts Lagoon Tourmaline lot', 'Lagoon tourmaline lot 

Bright colour 

More Beautiful In Real And At very reasonable price 

5.45 Cts
4.2 to 6.1mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 267, 1, 'loose_stone', 'Tourmaline', NULL, 5.45, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/ce23b8d2-5be0-48d6-a4c2-e7c29feef131/etsy-1.jpg","https://media.gemworkers.com/items/ce23b8d2-5be0-48d6-a4c2-e7c29feef131/etsy-2.jpg","https://media.gemworkers.com/items/ce23b8d2-5be0-48d6-a4c2-e7c29feef131/etsy-3.jpg","https://media.gemworkers.com/items/ce23b8d2-5be0-48d6-a4c2-e7c29feef131/etsy-4.jpg","https://media.gemworkers.com/items/ce23b8d2-5be0-48d6-a4c2-e7c29feef131/etsy-5.jpg","https://media.gemworkers.com/items/ce23b8d2-5be0-48d6-a4c2-e7c29feef131/etsy-6.jpg","https://media.gemworkers.com/items/ce23b8d2-5be0-48d6-a4c2-e7c29feef131/etsy-7.jpg","https://media.gemworkers.com/items/ce23b8d2-5be0-48d6-a4c2-e7c29feef131/etsy-8.jpg","https://media.gemworkers.com/items/ce23b8d2-5be0-48d6-a4c2-e7c29feef131/etsy-9.jpg","https://media.gemworkers.com/items/ce23b8d2-5be0-48d6-a4c2-e7c29feef131/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 299 USD, converted at ECB rate. Etsy tags: Paraiba Tourmaline,Paraiba Colour,Lagoon Tourmaline,Bluegreen Tourmaline,Blue Tourmaline,Neon Blue Tourmaline,Tourmaline Jewellery,Jewellers,Lagoon Colour,Oceangemsminerals,Ink Blue Tourmaline,Rings For Women,bicolour tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('6e0e97a7-4883-4ce2-a161-a169afcdef5e', 'Watermelon Tourmaline Gemstones: Rare Color, High Lustre, Sugar Inclusions (5.80 Cts)', 'Sweet Perfect Watermelon Tourmaline 

Unique And Rare Colour

Very Shiny And High Lustre

Sugar Inclusions Gives It More Beauty 

5.80 Cts
10 x 9.6 x 6.8mm

No treatment.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 356, 1, 'loose_stone', 'Tourmaline', 'Watermelon', 5.8, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/6e0e97a7-4883-4ce2-a161-a169afcdef5e/etsy-1.jpg","https://media.gemworkers.com/items/6e0e97a7-4883-4ce2-a161-a169afcdef5e/etsy-2.jpg","https://media.gemworkers.com/items/6e0e97a7-4883-4ce2-a161-a169afcdef5e/etsy-3.jpg","https://media.gemworkers.com/items/6e0e97a7-4883-4ce2-a161-a169afcdef5e/etsy-4.jpg","https://media.gemworkers.com/items/6e0e97a7-4883-4ce2-a161-a169afcdef5e/etsy-5.jpg","https://media.gemworkers.com/items/6e0e97a7-4883-4ce2-a161-a169afcdef5e/etsy-6.jpg","https://media.gemworkers.com/items/6e0e97a7-4883-4ce2-a161-a169afcdef5e/etsy-7.jpg","https://media.gemworkers.com/items/6e0e97a7-4883-4ce2-a161-a169afcdef5e/etsy-8.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 399 USD, converted at ECB rate. Etsy tags: Tourmaline Jewellery,Tourmaline Earrings,Earrings Stud,y2k earrings stud,Gold Rings,Natural Stone,Gift For Her,Rings For Men,Oceangemsminerals,lagoon tourmaline,tourmaline pairs,bicolour tourmaline,Watermelon Bicolour.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('480a9e80-fc5f-4bce-a1e3-dd5676fe07ec', '3.4 Cts Seafoam Tourmaline', 'Seafoam Blue colour tourmaline

top colour high lustre and brilliance 

Paraiba Like Colour

3.40 Cts
9.4 x 8.4 x 6mm

100% natural no treatment whatsoever.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 223, 1, 'loose_stone', 'Tourmaline', NULL, 3.4, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/480a9e80-fc5f-4bce-a1e3-dd5676fe07ec/etsy-1.jpg","https://media.gemworkers.com/items/480a9e80-fc5f-4bce-a1e3-dd5676fe07ec/etsy-2.jpg","https://media.gemworkers.com/items/480a9e80-fc5f-4bce-a1e3-dd5676fe07ec/etsy-3.jpg","https://media.gemworkers.com/items/480a9e80-fc5f-4bce-a1e3-dd5676fe07ec/etsy-4.jpg","https://media.gemworkers.com/items/480a9e80-fc5f-4bce-a1e3-dd5676fe07ec/etsy-5.jpg","https://media.gemworkers.com/items/480a9e80-fc5f-4bce-a1e3-dd5676fe07ec/etsy-6.jpg","https://media.gemworkers.com/items/480a9e80-fc5f-4bce-a1e3-dd5676fe07ec/etsy-7.jpg","https://media.gemworkers.com/items/480a9e80-fc5f-4bce-a1e3-dd5676fe07ec/etsy-8.jpg","https://media.gemworkers.com/items/480a9e80-fc5f-4bce-a1e3-dd5676fe07ec/etsy-9.jpg","https://media.gemworkers.com/items/480a9e80-fc5f-4bce-a1e3-dd5676fe07ec/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 250 USD, converted at ECB rate. Etsy tags: Natural Stone,Jewellery Supplies,Jewellery Making,Jewellery Findings,y2k stud earrings,Gift For Her,Rings For Men,Rings For Women,Gold Rings,Silver Sterling,Garnet Necklace,Garnet Rings,Garnet Jewellery.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('fd341e0e-a2f3-4438-943e-3f5e9318232b', '2.5 Cts Lagoon Tourmaline', 'lagoon and neon blue colour tourmaline

top colour high lustre and brilliance 

Paraiba Like Colour

2.50 Cts
7.8 x 7.3 x 5.8mm

100% natural no treatment whatsoever.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 223, 1, 'loose_stone', 'Tourmaline', NULL, 2.5, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/fd341e0e-a2f3-4438-943e-3f5e9318232b/etsy-1.jpg","https://media.gemworkers.com/items/fd341e0e-a2f3-4438-943e-3f5e9318232b/etsy-2.jpg","https://media.gemworkers.com/items/fd341e0e-a2f3-4438-943e-3f5e9318232b/etsy-3.jpg","https://media.gemworkers.com/items/fd341e0e-a2f3-4438-943e-3f5e9318232b/etsy-4.jpg","https://media.gemworkers.com/items/fd341e0e-a2f3-4438-943e-3f5e9318232b/etsy-5.jpg","https://media.gemworkers.com/items/fd341e0e-a2f3-4438-943e-3f5e9318232b/etsy-6.jpg","https://media.gemworkers.com/items/fd341e0e-a2f3-4438-943e-3f5e9318232b/etsy-7.jpg","https://media.gemworkers.com/items/fd341e0e-a2f3-4438-943e-3f5e9318232b/etsy-8.jpg","https://media.gemworkers.com/items/fd341e0e-a2f3-4438-943e-3f5e9318232b/etsy-9.jpg","https://media.gemworkers.com/items/fd341e0e-a2f3-4438-943e-3f5e9318232b/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 250 USD, converted at ECB rate. Etsy tags: Natural Stone,Jewellery Supplies,Jewellery Making,Jewellery Findings,y2k stud earrings,Gift For Her,Rings For Men,Rings For Women,Gold Rings,Silver Sterling,Garnet Necklace,Garnet Rings,Garnet Jewellery.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('998b1e46-416f-4e88-bbbd-e345116bbd47', '6.60 Cts Blue Tourmaline Lot', 'Blue and Teal Blue Colour Tourmaline Lot

One of a kind, top colours and and clarity.

6.60 Cts
6.4 to 4.4mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 491, 1, 'loose_stone', 'Tourmaline', NULL, 6.6, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/998b1e46-416f-4e88-bbbd-e345116bbd47/etsy-1.jpg","https://media.gemworkers.com/items/998b1e46-416f-4e88-bbbd-e345116bbd47/etsy-2.jpg","https://media.gemworkers.com/items/998b1e46-416f-4e88-bbbd-e345116bbd47/etsy-3.jpg","https://media.gemworkers.com/items/998b1e46-416f-4e88-bbbd-e345116bbd47/etsy-4.jpg","https://media.gemworkers.com/items/998b1e46-416f-4e88-bbbd-e345116bbd47/etsy-5.jpg","https://media.gemworkers.com/items/998b1e46-416f-4e88-bbbd-e345116bbd47/etsy-6.jpg","https://media.gemworkers.com/items/998b1e46-416f-4e88-bbbd-e345116bbd47/etsy-7.jpg","https://media.gemworkers.com/items/998b1e46-416f-4e88-bbbd-e345116bbd47/etsy-8.jpg","https://media.gemworkers.com/items/998b1e46-416f-4e88-bbbd-e345116bbd47/etsy-9.jpg","https://media.gemworkers.com/items/998b1e46-416f-4e88-bbbd-e345116bbd47/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 550 USD, converted at ECB rate. Etsy tags: Paraiba Tourmaline,Paraiba Colour,Lagoon Tourmaline,Bluegreen Tourmaline,Blue Tourmaline,Neon Blue Tourmaline,Tourmaline Jewellery,Jewellers,Lagoon Colour,Oceangemsminerals,Ink Blue Tourmaline,Wedding Rings,Rings For Women.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('54335d28-c332-43fe-b50e-90515eb9f545', '12.10 Cts Blue Tourmaline Lot', 'Blue and Lagoon Colour Tourmaline Lot

One of a kind, top colours and and clarity.

12.10 Cts
10.3 to 6mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 491, 1, 'loose_stone', 'Tourmaline', NULL, 12.1, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/54335d28-c332-43fe-b50e-90515eb9f545/etsy-1.jpg","https://media.gemworkers.com/items/54335d28-c332-43fe-b50e-90515eb9f545/etsy-2.jpg","https://media.gemworkers.com/items/54335d28-c332-43fe-b50e-90515eb9f545/etsy-3.jpg","https://media.gemworkers.com/items/54335d28-c332-43fe-b50e-90515eb9f545/etsy-4.jpg","https://media.gemworkers.com/items/54335d28-c332-43fe-b50e-90515eb9f545/etsy-5.jpg","https://media.gemworkers.com/items/54335d28-c332-43fe-b50e-90515eb9f545/etsy-6.jpg","https://media.gemworkers.com/items/54335d28-c332-43fe-b50e-90515eb9f545/etsy-7.jpg","https://media.gemworkers.com/items/54335d28-c332-43fe-b50e-90515eb9f545/etsy-8.jpg","https://media.gemworkers.com/items/54335d28-c332-43fe-b50e-90515eb9f545/etsy-9.jpg","https://media.gemworkers.com/items/54335d28-c332-43fe-b50e-90515eb9f545/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 550 USD, converted at ECB rate. Etsy tags: Paraiba Tourmaline,Paraiba Colour,Lagoon Tourmaline,Bluegreen Tourmaline,Blue Tourmaline,Neon Blue Tourmaline,Tourmaline Jewellery,Jewellers,Lagoon Colour,Oceangemsminerals,Ink Blue Tourmaline,Wedding Rings,Rings For Women.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('e75b38b8-b1bf-4b28-ac7f-07eea9f84d0b', '5.20 Cts Blue Tourmaline Lot', 'Blue and Teal Blue Colour Tourmaline Lot

One of a kind, top colours and and clarity.

5.20 Cts
7.5 to 4.2mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 179, 1, 'loose_stone', 'Tourmaline', NULL, 5.2, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/e75b38b8-b1bf-4b28-ac7f-07eea9f84d0b/etsy-1.jpg","https://media.gemworkers.com/items/e75b38b8-b1bf-4b28-ac7f-07eea9f84d0b/etsy-2.jpg","https://media.gemworkers.com/items/e75b38b8-b1bf-4b28-ac7f-07eea9f84d0b/etsy-3.jpg","https://media.gemworkers.com/items/e75b38b8-b1bf-4b28-ac7f-07eea9f84d0b/etsy-4.jpg","https://media.gemworkers.com/items/e75b38b8-b1bf-4b28-ac7f-07eea9f84d0b/etsy-5.jpg","https://media.gemworkers.com/items/e75b38b8-b1bf-4b28-ac7f-07eea9f84d0b/etsy-6.jpg","https://media.gemworkers.com/items/e75b38b8-b1bf-4b28-ac7f-07eea9f84d0b/etsy-7.jpg","https://media.gemworkers.com/items/e75b38b8-b1bf-4b28-ac7f-07eea9f84d0b/etsy-8.jpg","https://media.gemworkers.com/items/e75b38b8-b1bf-4b28-ac7f-07eea9f84d0b/etsy-9.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 200 USD, converted at ECB rate. Etsy tags: Paraiba Tourmaline,Paraiba Colour,Lagoon Tourmaline,Bluegreen Tourmaline,Blue Tourmaline,Neon Blue Tourmaline,Tourmaline Jewellery,Jewellers,Lagoon Colour,Oceangemsminerals,Ink Blue Tourmaline,Wedding Rings,Rings For Women.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('27d78f81-b114-4221-8ee8-e874383fd171', '3.20Cts, Lagoon Bicolour Tourmaline.', 'Gorgeous Mesmerising Bicolour Lagoon Green Natural Afghanistan Tourmaline 

More beautiful In real, One of a kind

3.20 Cts
12 x 5.5 x 5mm

unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 161, 1, 'loose_stone', 'Tourmaline', NULL, 3.2, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/27d78f81-b114-4221-8ee8-e874383fd171/etsy-1.jpg","https://media.gemworkers.com/items/27d78f81-b114-4221-8ee8-e874383fd171/etsy-2.jpg","https://media.gemworkers.com/items/27d78f81-b114-4221-8ee8-e874383fd171/etsy-3.jpg","https://media.gemworkers.com/items/27d78f81-b114-4221-8ee8-e874383fd171/etsy-4.jpg","https://media.gemworkers.com/items/27d78f81-b114-4221-8ee8-e874383fd171/etsy-5.jpg","https://media.gemworkers.com/items/27d78f81-b114-4221-8ee8-e874383fd171/etsy-6.jpg","https://media.gemworkers.com/items/27d78f81-b114-4221-8ee8-e874383fd171/etsy-7.jpg","https://media.gemworkers.com/items/27d78f81-b114-4221-8ee8-e874383fd171/etsy-8.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 180 USD, converted at ECB rate. Etsy tags: Gold Rings,Rings For Men,Tourmaline Jewellery,Natural Stone,bicolour Tourmaline,Lagoon tourmaline,Bluegreen tourmaline,blue tourmaline,indicolite tourmalin,tourmaline rings,faceted tourmaline,Oceangemsminerals,tourmaline lot.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('9d6d6f21-0883-49f7-b97b-136d06203ab5', '5.20 Cts Pink Tourmaline Pair', 'Gorgeous Pink Tourmaline Pair 

One Is Loupe Clean Other one is Almost Eye Clean

5.20 Cts
7.5 x 7.3 x 6mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 624, 1, 'loose_stone', 'Tourmaline', NULL, 5.2, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/9d6d6f21-0883-49f7-b97b-136d06203ab5/etsy-1.jpg","https://media.gemworkers.com/items/9d6d6f21-0883-49f7-b97b-136d06203ab5/etsy-2.jpg","https://media.gemworkers.com/items/9d6d6f21-0883-49f7-b97b-136d06203ab5/etsy-3.jpg","https://media.gemworkers.com/items/9d6d6f21-0883-49f7-b97b-136d06203ab5/etsy-4.jpg","https://media.gemworkers.com/items/9d6d6f21-0883-49f7-b97b-136d06203ab5/etsy-5.jpg","https://media.gemworkers.com/items/9d6d6f21-0883-49f7-b97b-136d06203ab5/etsy-6.jpg","https://media.gemworkers.com/items/9d6d6f21-0883-49f7-b97b-136d06203ab5/etsy-7.jpg","https://media.gemworkers.com/items/9d6d6f21-0883-49f7-b97b-136d06203ab5/etsy-8.jpg","https://media.gemworkers.com/items/9d6d6f21-0883-49f7-b97b-136d06203ab5/etsy-9.jpg","https://media.gemworkers.com/items/9d6d6f21-0883-49f7-b97b-136d06203ab5/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 699 USD, converted at ECB rate. Etsy tags: pink tourmaline,rings for women,unique tourmaline,jewels,Handmadejewellery,gift for her,Topqualitytourmaline,Bicolour Tourmaline,Unique Bicolour,Rare Tourmaline,Oceangemsminerals,Tourmaline Pairs,Bicolour Pairs.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('4c26151d-e455-41ad-b1d3-7a4d8b5f9acc', '58 Cts Pink Tourmaline Cabochon Lot', 'Gorgeous Pink And Yellow Tourmaline Cabochon Lot

High Lustre And Nice Polished

58 Cts
10 to 13.5mm

unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 268, 1, 'loose_stone', 'Tourmaline', NULL, 58, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/4c26151d-e455-41ad-b1d3-7a4d8b5f9acc/etsy-1.jpg","https://media.gemworkers.com/items/4c26151d-e455-41ad-b1d3-7a4d8b5f9acc/etsy-2.jpg","https://media.gemworkers.com/items/4c26151d-e455-41ad-b1d3-7a4d8b5f9acc/etsy-3.jpg","https://media.gemworkers.com/items/4c26151d-e455-41ad-b1d3-7a4d8b5f9acc/etsy-4.jpg","https://media.gemworkers.com/items/4c26151d-e455-41ad-b1d3-7a4d8b5f9acc/etsy-5.jpg","https://media.gemworkers.com/items/4c26151d-e455-41ad-b1d3-7a4d8b5f9acc/etsy-6.jpg","https://media.gemworkers.com/items/4c26151d-e455-41ad-b1d3-7a4d8b5f9acc/etsy-7.jpg","https://media.gemworkers.com/items/4c26151d-e455-41ad-b1d3-7a4d8b5f9acc/etsy-8.jpg","https://media.gemworkers.com/items/4c26151d-e455-41ad-b1d3-7a4d8b5f9acc/etsy-9.jpg","https://media.gemworkers.com/items/4c26151d-e455-41ad-b1d3-7a4d8b5f9acc/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 300 USD, converted at ECB rate. Etsy tags: Santa Maria Cabochon,Bicolour Cabochons,Blue Cabochons,Lagoon Cabochons,Natural Stone,Oceangemsminerals,Tourmaline Rosecuts,Lagoon Rosecuts,Blue Tourmaline,Blue Rosecuts,Pink Cabochon,Green Cabochon,Canary Tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('3aa740ed-d971-4b92-a780-b267163a6c82', '39.60 Cts Pink And Yellow Tourmaline Cabochon Lot', 'Gorgeous Pink And Yellow Tourmaline Cabochon Lot

High Lustre And Nice Polished

39.60 Cts
6.4 to 11.5mm

unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 179, 1, 'loose_stone', 'Tourmaline', NULL, 39.6, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/3aa740ed-d971-4b92-a780-b267163a6c82/etsy-1.jpg","https://media.gemworkers.com/items/3aa740ed-d971-4b92-a780-b267163a6c82/etsy-2.jpg","https://media.gemworkers.com/items/3aa740ed-d971-4b92-a780-b267163a6c82/etsy-3.jpg","https://media.gemworkers.com/items/3aa740ed-d971-4b92-a780-b267163a6c82/etsy-4.jpg","https://media.gemworkers.com/items/3aa740ed-d971-4b92-a780-b267163a6c82/etsy-5.jpg","https://media.gemworkers.com/items/3aa740ed-d971-4b92-a780-b267163a6c82/etsy-6.jpg","https://media.gemworkers.com/items/3aa740ed-d971-4b92-a780-b267163a6c82/etsy-7.jpg","https://media.gemworkers.com/items/3aa740ed-d971-4b92-a780-b267163a6c82/etsy-8.jpg","https://media.gemworkers.com/items/3aa740ed-d971-4b92-a780-b267163a6c82/etsy-9.jpg","https://media.gemworkers.com/items/3aa740ed-d971-4b92-a780-b267163a6c82/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 200 USD, converted at ECB rate. Etsy tags: Santa Maria Cabochon,Bicolour Cabochons,Blue Cabochons,Lagoon Cabochons,Natural Stone,Oceangemsminerals,Tourmaline Rosecuts,Lagoon Rosecuts,Blue Tourmaline,Blue Rosecuts,Pink Cabochon,Green Cabochon,Canary Tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('0ba7eea7-105d-4c73-8763-62953a7ee5b2', '23.90 Cts Tourmaline Lot | Mix Colours |', 'Beautiful Tourmaline Mix Colour Lot

Good Size, Perfect For Jewellery Making

23.90 Cts
14.3 to 6.6mm

no treatment whatsoever', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 339, 1, 'loose_stone', 'Tourmaline', NULL, 23.9, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/0ba7eea7-105d-4c73-8763-62953a7ee5b2/etsy-1.jpg","https://media.gemworkers.com/items/0ba7eea7-105d-4c73-8763-62953a7ee5b2/etsy-2.jpg","https://media.gemworkers.com/items/0ba7eea7-105d-4c73-8763-62953a7ee5b2/etsy-3.jpg","https://media.gemworkers.com/items/0ba7eea7-105d-4c73-8763-62953a7ee5b2/etsy-4.jpg","https://media.gemworkers.com/items/0ba7eea7-105d-4c73-8763-62953a7ee5b2/etsy-5.jpg","https://media.gemworkers.com/items/0ba7eea7-105d-4c73-8763-62953a7ee5b2/etsy-6.jpg","https://media.gemworkers.com/items/0ba7eea7-105d-4c73-8763-62953a7ee5b2/etsy-7.jpg","https://media.gemworkers.com/items/0ba7eea7-105d-4c73-8763-62953a7ee5b2/etsy-8.jpg","https://media.gemworkers.com/items/0ba7eea7-105d-4c73-8763-62953a7ee5b2/etsy-9.jpg","https://media.gemworkers.com/items/0ba7eea7-105d-4c73-8763-62953a7ee5b2/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 380 USD, converted at ECB rate. Etsy tags: Jewellery Making,Jewellery Supplies,Jewellery Findings,Tourmaline Lot,Seafoam Tourmaline,Green Tourmaline,Tourmaline Jewellery,Gift For Her,Natural Stone,Pink Tourmaline,Stud Earrings,Hoop earrings,handmade.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('1c4ab9a2-3610-4596-a646-fa4f883b84d7', '68.69 Cts Peridot Cabochon Lot', 'bright Colour Sugar Loaf Peridot Cabochon Lot

origin- pakistan 

pakistan peridot is one of the finest and top quality 

68.60 Cts
25 x 11 x 7.8mm
12.3 x 12.3 x 9.2mm
12 x 11.4 x 7.6mm

unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 268, 1, 'loose_stone', 'Peridot', NULL, 68.69, 'ct', 'Pakistan', NULL, NULL, '["https://media.gemworkers.com/items/1c4ab9a2-3610-4596-a646-fa4f883b84d7/etsy-1.jpg","https://media.gemworkers.com/items/1c4ab9a2-3610-4596-a646-fa4f883b84d7/etsy-2.jpg","https://media.gemworkers.com/items/1c4ab9a2-3610-4596-a646-fa4f883b84d7/etsy-3.jpg","https://media.gemworkers.com/items/1c4ab9a2-3610-4596-a646-fa4f883b84d7/etsy-4.jpg","https://media.gemworkers.com/items/1c4ab9a2-3610-4596-a646-fa4f883b84d7/etsy-5.jpg","https://media.gemworkers.com/items/1c4ab9a2-3610-4596-a646-fa4f883b84d7/etsy-6.jpg","https://media.gemworkers.com/items/1c4ab9a2-3610-4596-a646-fa4f883b84d7/etsy-7.jpg","https://media.gemworkers.com/items/1c4ab9a2-3610-4596-a646-fa4f883b84d7/etsy-8.jpg","https://media.gemworkers.com/items/1c4ab9a2-3610-4596-a646-fa4f883b84d7/etsy-9.jpg","https://media.gemworkers.com/items/1c4ab9a2-3610-4596-a646-fa4f883b84d7/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 300 USD, converted at ECB rate. Etsy tags: jewellery making,jewellery supplies,jewellery findings,loose gemstones,gift for her,peridot pairs,peridot jewellery,pakistan peridot,green peridot,trillion peridot,y2k earrings stud,necklace findings,gold rings.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('03c1fad3-1188-4f40-8cee-dea7fe417450', '34.70 Cts Pink And Bicolour Tourmaline Cabochon Lot', 'Gorgeous Pink And Bi Colour Tourmaline Cabochon Lot

High Lustre And Nice Polished

34.70 Cts
10 to 13.5mm

unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 179, 1, 'loose_stone', 'Tourmaline', NULL, 34.7, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/03c1fad3-1188-4f40-8cee-dea7fe417450/etsy-1.jpg","https://media.gemworkers.com/items/03c1fad3-1188-4f40-8cee-dea7fe417450/etsy-2.jpg","https://media.gemworkers.com/items/03c1fad3-1188-4f40-8cee-dea7fe417450/etsy-3.jpg","https://media.gemworkers.com/items/03c1fad3-1188-4f40-8cee-dea7fe417450/etsy-4.jpg","https://media.gemworkers.com/items/03c1fad3-1188-4f40-8cee-dea7fe417450/etsy-5.jpg","https://media.gemworkers.com/items/03c1fad3-1188-4f40-8cee-dea7fe417450/etsy-6.jpg","https://media.gemworkers.com/items/03c1fad3-1188-4f40-8cee-dea7fe417450/etsy-7.jpg","https://media.gemworkers.com/items/03c1fad3-1188-4f40-8cee-dea7fe417450/etsy-8.jpg","https://media.gemworkers.com/items/03c1fad3-1188-4f40-8cee-dea7fe417450/etsy-9.jpg","https://media.gemworkers.com/items/03c1fad3-1188-4f40-8cee-dea7fe417450/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 200 USD, converted at ECB rate. Etsy tags: Santa Maria Cabochon,Bicolour Cabochons,Blue Cabochons,Lagoon Cabochons,Natural Stone,Oceangemsminerals,Tourmaline Rosecuts,Lagoon Rosecuts,Blue Tourmaline,Blue Rosecuts,Pink Cabochon,Green Cabochon,Canary Tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('8fed0b56-cf20-4cd0-b5fc-6cebe26e6b69', '55.30 Cts Canary Tourmaline Cabochons', 'Gorgeous Mix Colour Tourmaline Big Size Cabochons

High Lustre And Nice Polished

55.30 Cts
6.5 to 11.5mm

unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 286, 1, 'loose_stone', 'Tourmaline', NULL, 55.3, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/8fed0b56-cf20-4cd0-b5fc-6cebe26e6b69/etsy-1.jpg","https://media.gemworkers.com/items/8fed0b56-cf20-4cd0-b5fc-6cebe26e6b69/etsy-2.jpg","https://media.gemworkers.com/items/8fed0b56-cf20-4cd0-b5fc-6cebe26e6b69/etsy-3.jpg","https://media.gemworkers.com/items/8fed0b56-cf20-4cd0-b5fc-6cebe26e6b69/etsy-4.jpg","https://media.gemworkers.com/items/8fed0b56-cf20-4cd0-b5fc-6cebe26e6b69/etsy-5.jpg","https://media.gemworkers.com/items/8fed0b56-cf20-4cd0-b5fc-6cebe26e6b69/etsy-6.jpg","https://media.gemworkers.com/items/8fed0b56-cf20-4cd0-b5fc-6cebe26e6b69/etsy-7.jpg","https://media.gemworkers.com/items/8fed0b56-cf20-4cd0-b5fc-6cebe26e6b69/etsy-8.jpg","https://media.gemworkers.com/items/8fed0b56-cf20-4cd0-b5fc-6cebe26e6b69/etsy-9.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 320 USD, converted at ECB rate. Etsy tags: Santa Maria Cabochon,Unique Aquamarine,Bicolour Aquamarine,Bicolour Cabochons,Blue Cabochons,Lagoon Cabochons,Natural Stone,jewels,Oceangemsminerals,Tourmaline Rosecuts,Lagoon Rosecuts,Blue Tourmaline,Canary Tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('9f4b3511-5b8e-4938-95a0-9e90d78525aa', '74 Cts Canary Tourmaline Cabochons', 'Gorgeous Mix Colour Tourmaline Big Size Cabochons

High Lustre And Nice Polished

74 Cts
9.5 to 17.5mm

unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 313, 1, 'loose_stone', 'Tourmaline', NULL, 74, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/9f4b3511-5b8e-4938-95a0-9e90d78525aa/etsy-1.jpg","https://media.gemworkers.com/items/9f4b3511-5b8e-4938-95a0-9e90d78525aa/etsy-2.jpg","https://media.gemworkers.com/items/9f4b3511-5b8e-4938-95a0-9e90d78525aa/etsy-3.jpg","https://media.gemworkers.com/items/9f4b3511-5b8e-4938-95a0-9e90d78525aa/etsy-4.jpg","https://media.gemworkers.com/items/9f4b3511-5b8e-4938-95a0-9e90d78525aa/etsy-5.jpg","https://media.gemworkers.com/items/9f4b3511-5b8e-4938-95a0-9e90d78525aa/etsy-6.jpg","https://media.gemworkers.com/items/9f4b3511-5b8e-4938-95a0-9e90d78525aa/etsy-7.jpg","https://media.gemworkers.com/items/9f4b3511-5b8e-4938-95a0-9e90d78525aa/etsy-8.jpg","https://media.gemworkers.com/items/9f4b3511-5b8e-4938-95a0-9e90d78525aa/etsy-9.jpg","https://media.gemworkers.com/items/9f4b3511-5b8e-4938-95a0-9e90d78525aa/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 350 USD, converted at ECB rate. Etsy tags: Santa Maria Cabochon,Unique Aquamarine,Bicolour Aquamarine,Bicolour Cabochons,Blue Cabochons,Lagoon Cabochons,Natural Stone,jewels,Oceangemsminerals,Tourmaline Rosecuts,Lagoon Rosecuts,Blue Tourmaline,Canary Tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('e399d35b-5014-4ea2-abe4-fbdbb4a09d8b', '2.70 Cts Yellow Sapphire Lot', 'Gorgeous Yellow Sapphire Lot

Shiny And Lustrous 

2.7 Cts
6.4 to 5mm', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 268, 1, 'loose_stone', 'Sapphire', NULL, 2.7, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/e399d35b-5014-4ea2-abe4-fbdbb4a09d8b/etsy-1.jpg","https://media.gemworkers.com/items/e399d35b-5014-4ea2-abe4-fbdbb4a09d8b/etsy-2.jpg","https://media.gemworkers.com/items/e399d35b-5014-4ea2-abe4-fbdbb4a09d8b/etsy-3.jpg","https://media.gemworkers.com/items/e399d35b-5014-4ea2-abe4-fbdbb4a09d8b/etsy-4.jpg","https://media.gemworkers.com/items/e399d35b-5014-4ea2-abe4-fbdbb4a09d8b/etsy-5.jpg","https://media.gemworkers.com/items/e399d35b-5014-4ea2-abe4-fbdbb4a09d8b/etsy-6.jpg","https://media.gemworkers.com/items/e399d35b-5014-4ea2-abe4-fbdbb4a09d8b/etsy-7.jpg","https://media.gemworkers.com/items/e399d35b-5014-4ea2-abe4-fbdbb4a09d8b/etsy-8.jpg","https://media.gemworkers.com/items/e399d35b-5014-4ea2-abe4-fbdbb4a09d8b/etsy-9.jpg","https://media.gemworkers.com/items/e399d35b-5014-4ea2-abe4-fbdbb4a09d8b/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 300 USD, converted at ECB rate. Etsy tags: Multi Colour Saphire,Sapphire Lot,Sapphire Crystal,Sapphire Jewellery,Bicolour Sapphire,Mix Colour Lot,Precious Stone,Homemade Jewellery,Jewellery Making,Blue Sapphire,Yellow Sapphire,Oceangemsminerals,Mix Sapphire.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('97cc05ec-31dc-4b64-8dcb-ff013ea0c22f', '3.00 Cts Yellow Sapphire Pair', 'Gorgeous Yellow Sapphire Pair

Shiny And Lustrous 

3.00 Cts
7.7 x 6 x 3.4mm', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 357, 1, 'loose_stone', 'Sapphire', NULL, 3, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/97cc05ec-31dc-4b64-8dcb-ff013ea0c22f/etsy-1.jpg","https://media.gemworkers.com/items/97cc05ec-31dc-4b64-8dcb-ff013ea0c22f/etsy-2.jpg","https://media.gemworkers.com/items/97cc05ec-31dc-4b64-8dcb-ff013ea0c22f/etsy-3.jpg","https://media.gemworkers.com/items/97cc05ec-31dc-4b64-8dcb-ff013ea0c22f/etsy-4.jpg","https://media.gemworkers.com/items/97cc05ec-31dc-4b64-8dcb-ff013ea0c22f/etsy-5.jpg","https://media.gemworkers.com/items/97cc05ec-31dc-4b64-8dcb-ff013ea0c22f/etsy-6.jpg","https://media.gemworkers.com/items/97cc05ec-31dc-4b64-8dcb-ff013ea0c22f/etsy-7.jpg","https://media.gemworkers.com/items/97cc05ec-31dc-4b64-8dcb-ff013ea0c22f/etsy-8.jpg","https://media.gemworkers.com/items/97cc05ec-31dc-4b64-8dcb-ff013ea0c22f/etsy-9.jpg","https://media.gemworkers.com/items/97cc05ec-31dc-4b64-8dcb-ff013ea0c22f/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 400 USD, converted at ECB rate. Etsy tags: Multi Colour Saphire,Sapphire Lot,Sapphire Crystal,Sapphire Jewellery,Bicolour Sapphire,Mix Colour Lot,Precious Stone,Homemade Jewellery,Jewellery Making,Blue Sapphire,Yellow Sapphire,Oceangemsminerals,Mix Sapphire.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('7c43f72b-4db1-4da9-b83b-60dd0353f98f', '1.25 Cts Yellow Sapphire', 'Gorgeous Yellow Sapphire 

Shiny And Lustrous 

1.25 Cts
6.3 x 5.4 x 3.6mm', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 143, 1, 'loose_stone', 'Sapphire', NULL, 1.25, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/7c43f72b-4db1-4da9-b83b-60dd0353f98f/etsy-1.jpg","https://media.gemworkers.com/items/7c43f72b-4db1-4da9-b83b-60dd0353f98f/etsy-2.jpg","https://media.gemworkers.com/items/7c43f72b-4db1-4da9-b83b-60dd0353f98f/etsy-3.jpg","https://media.gemworkers.com/items/7c43f72b-4db1-4da9-b83b-60dd0353f98f/etsy-4.jpg","https://media.gemworkers.com/items/7c43f72b-4db1-4da9-b83b-60dd0353f98f/etsy-5.jpg","https://media.gemworkers.com/items/7c43f72b-4db1-4da9-b83b-60dd0353f98f/etsy-6.jpg","https://media.gemworkers.com/items/7c43f72b-4db1-4da9-b83b-60dd0353f98f/etsy-7.jpg","https://media.gemworkers.com/items/7c43f72b-4db1-4da9-b83b-60dd0353f98f/etsy-8.jpg","https://media.gemworkers.com/items/7c43f72b-4db1-4da9-b83b-60dd0353f98f/etsy-9.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 160 USD, converted at ECB rate. Etsy tags: Multi Colour Saphire,Sapphire Lot,Sapphire Crystal,Sapphire Jewellery,Bicolour Sapphire,Mix Colour Lot,Precious Stone,Homemade Jewellery,Jewellery Making,Blue Sapphire,Yellow Sapphire,Oceangemsminerals,Mix Sapphire.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('710315a5-5cbb-48f6-8d8e-4e7907ef385d', '14.20 Cts Vibrant Tourmaline Gemstone Lot: Unheated, Untreated', 'Top Quality Tourmaline Lot

Best and vibrant colours 

14.20 Cts
17.2 to 8.2mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 313, 1, 'loose_stone', 'Tourmaline', NULL, 14.2, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/710315a5-5cbb-48f6-8d8e-4e7907ef385d/etsy-1.jpg","https://media.gemworkers.com/items/710315a5-5cbb-48f6-8d8e-4e7907ef385d/etsy-2.jpg","https://media.gemworkers.com/items/710315a5-5cbb-48f6-8d8e-4e7907ef385d/etsy-3.jpg","https://media.gemworkers.com/items/710315a5-5cbb-48f6-8d8e-4e7907ef385d/etsy-4.jpg","https://media.gemworkers.com/items/710315a5-5cbb-48f6-8d8e-4e7907ef385d/etsy-5.jpg","https://media.gemworkers.com/items/710315a5-5cbb-48f6-8d8e-4e7907ef385d/etsy-6.jpg","https://media.gemworkers.com/items/710315a5-5cbb-48f6-8d8e-4e7907ef385d/etsy-7.jpg","https://media.gemworkers.com/items/710315a5-5cbb-48f6-8d8e-4e7907ef385d/etsy-8.jpg","https://media.gemworkers.com/items/710315a5-5cbb-48f6-8d8e-4e7907ef385d/etsy-9.jpg","https://media.gemworkers.com/items/710315a5-5cbb-48f6-8d8e-4e7907ef385d/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 350 USD, converted at ECB rate. Etsy tags: Tourmaline Lot,Tourmaline Jewellery,Bluegreen Tourmaline,Lagoon Tourmaline,Blue Tourmaline,Green Tourmaline,Seafoam Tourmaline,Bicolour Tourmaline,Oceangemsminerals,Mint Tourmaline,Vivid Tourmaline Lot,Tourmaline Supplies,Jewellers.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('9203d680-c164-4294-82bb-94589872fa13', '1.55 Cts Blue Green Tourmaline', 'Top Quality Blue Green Tourmaline  

rare find

1.55 Cts
7.5 x 5.4 x 4.3mm

No Treatment Whatsoever.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 250, 1, 'loose_stone', 'Tourmaline', NULL, 1.55, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/9203d680-c164-4294-82bb-94589872fa13/etsy-1.jpg","https://media.gemworkers.com/items/9203d680-c164-4294-82bb-94589872fa13/etsy-2.jpg","https://media.gemworkers.com/items/9203d680-c164-4294-82bb-94589872fa13/etsy-3.jpg","https://media.gemworkers.com/items/9203d680-c164-4294-82bb-94589872fa13/etsy-4.jpg","https://media.gemworkers.com/items/9203d680-c164-4294-82bb-94589872fa13/etsy-5.jpg","https://media.gemworkers.com/items/9203d680-c164-4294-82bb-94589872fa13/etsy-6.jpg","https://media.gemworkers.com/items/9203d680-c164-4294-82bb-94589872fa13/etsy-7.jpg","https://media.gemworkers.com/items/9203d680-c164-4294-82bb-94589872fa13/etsy-8.jpg","https://media.gemworkers.com/items/9203d680-c164-4294-82bb-94589872fa13/etsy-9.jpg","https://media.gemworkers.com/items/9203d680-c164-4294-82bb-94589872fa13/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 280 USD, converted at ECB rate. Etsy tags: Emerald Cut,EmeraldCutTourmaline,Jewellery making,earrings stud,Tourmaline Lot,Blue Tourmaline,Lagoon Tourmaline,Neon Blue,neon blue tourmaline,Rings For Men,Tourmalines,Ink Blue Tourmaline,Oceangemsminerals.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('03b57c73-c6d8-419b-a3fb-dd06940e851e', '11.10 Cts Vibrant Tourmaline Gemstone Lot: Unheated, Untreated', 'Top Quality Tourmaline Lot

Best and vibrant colours 


11.10 Cts
14.4 to 8.2mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 268, 1, 'loose_stone', 'Tourmaline', NULL, 11.1, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/03b57c73-c6d8-419b-a3fb-dd06940e851e/etsy-1.jpg","https://media.gemworkers.com/items/03b57c73-c6d8-419b-a3fb-dd06940e851e/etsy-2.jpg","https://media.gemworkers.com/items/03b57c73-c6d8-419b-a3fb-dd06940e851e/etsy-3.jpg","https://media.gemworkers.com/items/03b57c73-c6d8-419b-a3fb-dd06940e851e/etsy-4.jpg","https://media.gemworkers.com/items/03b57c73-c6d8-419b-a3fb-dd06940e851e/etsy-5.jpg","https://media.gemworkers.com/items/03b57c73-c6d8-419b-a3fb-dd06940e851e/etsy-6.jpg","https://media.gemworkers.com/items/03b57c73-c6d8-419b-a3fb-dd06940e851e/etsy-7.jpg","https://media.gemworkers.com/items/03b57c73-c6d8-419b-a3fb-dd06940e851e/etsy-8.jpg","https://media.gemworkers.com/items/03b57c73-c6d8-419b-a3fb-dd06940e851e/etsy-9.jpg","https://media.gemworkers.com/items/03b57c73-c6d8-419b-a3fb-dd06940e851e/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 300 USD, converted at ECB rate. Etsy tags: Tourmaline Lot,Tourmaline Jewellery,Bluegreen Tourmaline,Lagoon Tourmaline,Blue Tourmaline,Green Tourmaline,Seafoam Tourmaline,Bicolour Tourmaline,Oceangemsminerals,Mint Tourmaline,Vivid Tourmaline Lot,Tourmaline Supplies,Jewellers.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('0a920711-40fe-41d8-a7b6-dd5e3958a859', '11.20 Cts Vibrant Tourmaline Gemstone Lot: Unheated, Untreated', 'Top Quality Tourmaline Lot

Best and vibrant colours 

11.20 Cts
7.5 to 3.8mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 268, 1, 'loose_stone', 'Tourmaline', NULL, 11.2, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/0a920711-40fe-41d8-a7b6-dd5e3958a859/etsy-1.jpg","https://media.gemworkers.com/items/0a920711-40fe-41d8-a7b6-dd5e3958a859/etsy-2.jpg","https://media.gemworkers.com/items/0a920711-40fe-41d8-a7b6-dd5e3958a859/etsy-3.jpg","https://media.gemworkers.com/items/0a920711-40fe-41d8-a7b6-dd5e3958a859/etsy-4.jpg","https://media.gemworkers.com/items/0a920711-40fe-41d8-a7b6-dd5e3958a859/etsy-5.jpg","https://media.gemworkers.com/items/0a920711-40fe-41d8-a7b6-dd5e3958a859/etsy-6.jpg","https://media.gemworkers.com/items/0a920711-40fe-41d8-a7b6-dd5e3958a859/etsy-7.jpg","https://media.gemworkers.com/items/0a920711-40fe-41d8-a7b6-dd5e3958a859/etsy-8.jpg","https://media.gemworkers.com/items/0a920711-40fe-41d8-a7b6-dd5e3958a859/etsy-9.jpg","https://media.gemworkers.com/items/0a920711-40fe-41d8-a7b6-dd5e3958a859/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 300 USD, converted at ECB rate. Etsy tags: Tourmaline Lot,Tourmaline Jewellery,Bluegreen Tourmaline,Lagoon Tourmaline,Blue Tourmaline,Green Tourmaline,Seafoam Tourmaline,Bicolour Tourmaline,Oceangemsminerals,Mint Tourmaline,Vivid Tourmaline Lot,Tourmaline Supplies,Jewellers.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('1b8ece28-645a-4bdd-b6d3-29fe101d52ba', '1.65 Cts Neon Blue Bicolour Tourmaline', 'Top Quality Neon Blue Bicolour Tourmaline

rare find

1.65 Cts
8.7 x 4.9 x 3.9mm

No Treatment Whatsoever.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 281, 1, 'loose_stone', 'Tourmaline', NULL, 1.65, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/1b8ece28-645a-4bdd-b6d3-29fe101d52ba/etsy-1.jpg","https://media.gemworkers.com/items/1b8ece28-645a-4bdd-b6d3-29fe101d52ba/etsy-2.jpg","https://media.gemworkers.com/items/1b8ece28-645a-4bdd-b6d3-29fe101d52ba/etsy-3.jpg","https://media.gemworkers.com/items/1b8ece28-645a-4bdd-b6d3-29fe101d52ba/etsy-4.jpg","https://media.gemworkers.com/items/1b8ece28-645a-4bdd-b6d3-29fe101d52ba/etsy-5.jpg","https://media.gemworkers.com/items/1b8ece28-645a-4bdd-b6d3-29fe101d52ba/etsy-6.jpg","https://media.gemworkers.com/items/1b8ece28-645a-4bdd-b6d3-29fe101d52ba/etsy-7.jpg","https://media.gemworkers.com/items/1b8ece28-645a-4bdd-b6d3-29fe101d52ba/etsy-8.jpg","https://media.gemworkers.com/items/1b8ece28-645a-4bdd-b6d3-29fe101d52ba/etsy-9.jpg","https://media.gemworkers.com/items/1b8ece28-645a-4bdd-b6d3-29fe101d52ba/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 315 USD, converted at ECB rate. Etsy tags: Emerald Cut,EmeraldCutTourmaline,Jewellery making,earrings stud,Tourmaline Lot,Blue Tourmaline,Lagoon Tourmaline,Neon Blue,neon blue tourmaline,Rings For Men,Tourmalines,Ink Blue Tourmaline,Oceangemsminerals.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('200c4ce7-22a5-4bc5-a81e-163999096a70', '3 Cts Ice Blue Tourmaline Pair', 'Gorgeous Mesmerising Ice Blue Colour Natural Afghanistan Tourmaline Pair

More beautiful In real, One of a kind

3 Cts
6.2 x 5.6 x 5mm

unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 268, 1, 'loose_stone', 'Tourmaline', NULL, 3, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/200c4ce7-22a5-4bc5-a81e-163999096a70/etsy-1.jpg","https://media.gemworkers.com/items/200c4ce7-22a5-4bc5-a81e-163999096a70/etsy-2.jpg","https://media.gemworkers.com/items/200c4ce7-22a5-4bc5-a81e-163999096a70/etsy-3.jpg","https://media.gemworkers.com/items/200c4ce7-22a5-4bc5-a81e-163999096a70/etsy-4.jpg","https://media.gemworkers.com/items/200c4ce7-22a5-4bc5-a81e-163999096a70/etsy-5.jpg","https://media.gemworkers.com/items/200c4ce7-22a5-4bc5-a81e-163999096a70/etsy-6.jpg","https://media.gemworkers.com/items/200c4ce7-22a5-4bc5-a81e-163999096a70/etsy-7.jpg","https://media.gemworkers.com/items/200c4ce7-22a5-4bc5-a81e-163999096a70/etsy-8.jpg","https://media.gemworkers.com/items/200c4ce7-22a5-4bc5-a81e-163999096a70/etsy-9.jpg","https://media.gemworkers.com/items/200c4ce7-22a5-4bc5-a81e-163999096a70/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 300 USD, converted at ECB rate. Etsy tags: Jewellery Supplies,Jewellery Making,Gold Rings,Rings For Men,Rings For Women,y2k earrings stud,Gift For Her,Tourmaline Jewellery,Natural Stone,Stud Earrings,Jewellery Stud,bicolour Tourmaline,Lagoon tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('fbee8534-1c73-4eaf-b91e-36fcbdd13141', '1.60 Cts, Natural Bicolour Afghan Tourmaline', 'Gorgeous Mesmerising Natural Bicolour Afghan Tourmaline pair

high lustre, Saturated Colour.

1.60 Cts
7.9 x 5.7 x 3.6m

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 125, 1, 'loose_stone', 'Tourmaline', NULL, 1.6, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/fbee8534-1c73-4eaf-b91e-36fcbdd13141/etsy-1.jpg","https://media.gemworkers.com/items/fbee8534-1c73-4eaf-b91e-36fcbdd13141/etsy-2.jpg","https://media.gemworkers.com/items/fbee8534-1c73-4eaf-b91e-36fcbdd13141/etsy-3.jpg","https://media.gemworkers.com/items/fbee8534-1c73-4eaf-b91e-36fcbdd13141/etsy-4.jpg","https://media.gemworkers.com/items/fbee8534-1c73-4eaf-b91e-36fcbdd13141/etsy-5.jpg","https://media.gemworkers.com/items/fbee8534-1c73-4eaf-b91e-36fcbdd13141/etsy-6.jpg","https://media.gemworkers.com/items/fbee8534-1c73-4eaf-b91e-36fcbdd13141/etsy-7.jpg","https://media.gemworkers.com/items/fbee8534-1c73-4eaf-b91e-36fcbdd13141/etsy-8.jpg","https://media.gemworkers.com/items/fbee8534-1c73-4eaf-b91e-36fcbdd13141/etsy-9.jpg","https://media.gemworkers.com/items/fbee8534-1c73-4eaf-b91e-36fcbdd13141/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 140 USD, converted at ECB rate. Etsy tags: Tourmaline Rings,rings for women,rings for men,jewellery making,jewellery findings,gift for her,natural stone,Oceangemsminerals,apple green colour,Bicolour Tourmaline,Natural Bicolour,Unheated Tourmaline,Lipstick Tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('14201444-7bfd-479d-a8b6-9bac40f9349b', '4.30 Cts Rare Bicolour Tourmaline', 'Gorgeous Bicolour Tourmaline 

Ethically sourced, 
And at very reasonable price 
Highly recommending 

4.30 Cts 
17.3 x 6.6 x 4mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 313, 1, 'loose_stone', 'Tourmaline', NULL, 4.3, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/14201444-7bfd-479d-a8b6-9bac40f9349b/etsy-1.jpg","https://media.gemworkers.com/items/14201444-7bfd-479d-a8b6-9bac40f9349b/etsy-2.jpg","https://media.gemworkers.com/items/14201444-7bfd-479d-a8b6-9bac40f9349b/etsy-3.jpg","https://media.gemworkers.com/items/14201444-7bfd-479d-a8b6-9bac40f9349b/etsy-4.jpg","https://media.gemworkers.com/items/14201444-7bfd-479d-a8b6-9bac40f9349b/etsy-5.jpg","https://media.gemworkers.com/items/14201444-7bfd-479d-a8b6-9bac40f9349b/etsy-6.jpg","https://media.gemworkers.com/items/14201444-7bfd-479d-a8b6-9bac40f9349b/etsy-7.jpg","https://media.gemworkers.com/items/14201444-7bfd-479d-a8b6-9bac40f9349b/etsy-8.jpg","https://media.gemworkers.com/items/14201444-7bfd-479d-a8b6-9bac40f9349b/etsy-9.jpg","https://media.gemworkers.com/items/14201444-7bfd-479d-a8b6-9bac40f9349b/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 350 USD, converted at ECB rate. Etsy tags: Cushion cut,Tourmaline Rings,Tourmaline Jewellery,Bicolour Tourmaline,Earrings Stud,y2k earrings stud,Gold Rings,Gift For Her,Natural Stone,Rings For Men,Rings For Women,Jewellery making,Jewellery supplies.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('ef954abe-8389-489a-af72-a191305dab00', '3.20 Cts, Natural Bicolour Afghan Tourmalines', 'Gorgeous Mesmerising Natural Bicolour Watermelon Afghan Tourmalines

high lustre, Saturated Colour.

3.20 Cts
7.7 x 4.5 x 3.8mm
14 x 2.9 x 2.3mm
7.8 x 3.8 x 3.2mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 268, 1, 'loose_stone', 'Tourmaline', NULL, 3.2, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/ef954abe-8389-489a-af72-a191305dab00/etsy-1.jpg","https://media.gemworkers.com/items/ef954abe-8389-489a-af72-a191305dab00/etsy-2.jpg","https://media.gemworkers.com/items/ef954abe-8389-489a-af72-a191305dab00/etsy-3.jpg","https://media.gemworkers.com/items/ef954abe-8389-489a-af72-a191305dab00/etsy-4.jpg","https://media.gemworkers.com/items/ef954abe-8389-489a-af72-a191305dab00/etsy-5.jpg","https://media.gemworkers.com/items/ef954abe-8389-489a-af72-a191305dab00/etsy-6.jpg","https://media.gemworkers.com/items/ef954abe-8389-489a-af72-a191305dab00/etsy-7.jpg","https://media.gemworkers.com/items/ef954abe-8389-489a-af72-a191305dab00/etsy-8.jpg","https://media.gemworkers.com/items/ef954abe-8389-489a-af72-a191305dab00/etsy-9.jpg","https://media.gemworkers.com/items/ef954abe-8389-489a-af72-a191305dab00/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 300 USD, converted at ECB rate. Etsy tags: Tourmaline Rings,rings for women,rings for men,jewellery making,jewellery findings,gift for her,natural stone,Oceangemsminerals,apple green colour,Bicolour Tourmaline,Natural Bicolour,Unheated Tourmaline,Lipstick Tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('52e9e1b6-b702-4fe2-a849-21b1b0f6924d', '8.30 Cts Unique Bicolour Tourmaline Pairs / Pink, Green, Orange And Canary Colours | Ethically Sourced |', 'Gorgeous Mesmerising Natural Bicolour Afghan Tourmaline pair

Unique Bicolour Tourmaline Pairs / Pink, Green, Orange And Canary Colours | Ethically Sourced |

high lustre, Saturated Colour.

8.30 Cts
9.9 x 5.9 x 4.2mm
7.6 x 4.3 x 3.2m
6.7 x 4.5 x 3.5mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 268, 1, 'loose_stone', 'Tourmaline', NULL, 8.3, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/52e9e1b6-b702-4fe2-a849-21b1b0f6924d/etsy-1.jpg","https://media.gemworkers.com/items/52e9e1b6-b702-4fe2-a849-21b1b0f6924d/etsy-2.jpg","https://media.gemworkers.com/items/52e9e1b6-b702-4fe2-a849-21b1b0f6924d/etsy-3.jpg","https://media.gemworkers.com/items/52e9e1b6-b702-4fe2-a849-21b1b0f6924d/etsy-4.jpg","https://media.gemworkers.com/items/52e9e1b6-b702-4fe2-a849-21b1b0f6924d/etsy-5.jpg","https://media.gemworkers.com/items/52e9e1b6-b702-4fe2-a849-21b1b0f6924d/etsy-6.jpg","https://media.gemworkers.com/items/52e9e1b6-b702-4fe2-a849-21b1b0f6924d/etsy-7.jpg","https://media.gemworkers.com/items/52e9e1b6-b702-4fe2-a849-21b1b0f6924d/etsy-8.jpg","https://media.gemworkers.com/items/52e9e1b6-b702-4fe2-a849-21b1b0f6924d/etsy-9.jpg","https://media.gemworkers.com/items/52e9e1b6-b702-4fe2-a849-21b1b0f6924d/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 300 USD, converted at ECB rate. Etsy tags: Tourmaline Rings,rings for women,rings for men,jewellery making,jewellery findings,gift for her,natural stone,Oceangemsminerals,apple green colour,Bicolour Tourmaline,Natural Bicolour,Unheated Tourmaline,Lipstick Tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('de7a75ca-983d-450d-b94f-556304bdb671', '6.20 Cts Unique Bicolour Tourmaline Pairs / Orange And Canary Colours | Ethically Sourced |', 'Gorgeous Mesmerising Natural Bicolour Afghan Tourmaline pair

Unique Bicolour Tourmaline Pairs / Orange And Canary Colours | Ethically Sourced |

high lustre, Saturated Colour.

6.20 Cts
8.7 x 4.5 x 3.2mm
7.1 x 5 x 3.4mm
6.3 x 4.8 x 3.4mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 268, 1, 'loose_stone', 'Tourmaline', NULL, 6.2, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/de7a75ca-983d-450d-b94f-556304bdb671/etsy-1.jpg","https://media.gemworkers.com/items/de7a75ca-983d-450d-b94f-556304bdb671/etsy-2.jpg","https://media.gemworkers.com/items/de7a75ca-983d-450d-b94f-556304bdb671/etsy-3.jpg","https://media.gemworkers.com/items/de7a75ca-983d-450d-b94f-556304bdb671/etsy-4.jpg","https://media.gemworkers.com/items/de7a75ca-983d-450d-b94f-556304bdb671/etsy-5.jpg","https://media.gemworkers.com/items/de7a75ca-983d-450d-b94f-556304bdb671/etsy-6.jpg","https://media.gemworkers.com/items/de7a75ca-983d-450d-b94f-556304bdb671/etsy-7.jpg","https://media.gemworkers.com/items/de7a75ca-983d-450d-b94f-556304bdb671/etsy-8.jpg","https://media.gemworkers.com/items/de7a75ca-983d-450d-b94f-556304bdb671/etsy-9.jpg","https://media.gemworkers.com/items/de7a75ca-983d-450d-b94f-556304bdb671/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 300 USD, converted at ECB rate. Etsy tags: Tourmaline Rings,rings for women,rings for men,jewellery making,jewellery findings,gift for her,natural stone,Oceangemsminerals,apple green colour,Bicolour Tourmaline,Natural Bicolour,Unheated Tourmaline,Lipstick Tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('aad780e9-bc98-4e56-a47a-82de07b9406b', '5.10 Cts Unique Bicolour Tourmaline Pairs / Orange And Canary Colours | Ethically Sourced |', 'Gorgeous Mesmerising Natural Bicolour Afghan Tourmaline pair

Unique Bicolour Tourmaline Pairs / Orange And Canary Colours | Ethically Sourced |

high lustre, Saturated Colour.

5.10 Cts
7 x 5.1 x 4.1mm
6.6 x 4.9 x 3.6mm

Unheated, Untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 223, 1, 'loose_stone', 'Tourmaline', NULL, 5.1, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/aad780e9-bc98-4e56-a47a-82de07b9406b/etsy-1.jpg","https://media.gemworkers.com/items/aad780e9-bc98-4e56-a47a-82de07b9406b/etsy-2.jpg","https://media.gemworkers.com/items/aad780e9-bc98-4e56-a47a-82de07b9406b/etsy-3.jpg","https://media.gemworkers.com/items/aad780e9-bc98-4e56-a47a-82de07b9406b/etsy-4.jpg","https://media.gemworkers.com/items/aad780e9-bc98-4e56-a47a-82de07b9406b/etsy-5.jpg","https://media.gemworkers.com/items/aad780e9-bc98-4e56-a47a-82de07b9406b/etsy-6.jpg","https://media.gemworkers.com/items/aad780e9-bc98-4e56-a47a-82de07b9406b/etsy-7.jpg","https://media.gemworkers.com/items/aad780e9-bc98-4e56-a47a-82de07b9406b/etsy-8.jpg","https://media.gemworkers.com/items/aad780e9-bc98-4e56-a47a-82de07b9406b/etsy-9.jpg","https://media.gemworkers.com/items/aad780e9-bc98-4e56-a47a-82de07b9406b/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 250 USD, converted at ECB rate. Etsy tags: Tourmaline Rings,rings for women,rings for men,jewellery making,jewellery findings,gift for her,natural stone,Oceangemsminerals,apple green colour,Bicolour Tourmaline,Natural Bicolour,Unheated Tourmaline,Lipstick Tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('c98e22da-6f7f-4146-bb88-943344af85a9', '12.90 Cts Blue Bicolour Tourmaline', 'Bicolour Blue Mesmerising Afghan Tourmaline 

12.90 Cts
12.9 x 10.4 x 6.9mm

glowing 

unheated, untreated.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 402, 1, 'loose_stone', 'Tourmaline', NULL, 12.9, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/c98e22da-6f7f-4146-bb88-943344af85a9/etsy-1.jpg","https://media.gemworkers.com/items/c98e22da-6f7f-4146-bb88-943344af85a9/etsy-2.jpg","https://media.gemworkers.com/items/c98e22da-6f7f-4146-bb88-943344af85a9/etsy-3.jpg","https://media.gemworkers.com/items/c98e22da-6f7f-4146-bb88-943344af85a9/etsy-4.jpg","https://media.gemworkers.com/items/c98e22da-6f7f-4146-bb88-943344af85a9/etsy-5.jpg","https://media.gemworkers.com/items/c98e22da-6f7f-4146-bb88-943344af85a9/etsy-6.jpg","https://media.gemworkers.com/items/c98e22da-6f7f-4146-bb88-943344af85a9/etsy-7.jpg","https://media.gemworkers.com/items/c98e22da-6f7f-4146-bb88-943344af85a9/etsy-8.jpg","https://media.gemworkers.com/items/c98e22da-6f7f-4146-bb88-943344af85a9/etsy-9.jpg","https://media.gemworkers.com/items/c98e22da-6f7f-4146-bb88-943344af85a9/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 450 USD, converted at ECB rate. Etsy tags: Bicolour Tourmaline,Blue Tourmaline,Lagoon Tourmaline,Neon Tourmaline,Tourmaline jewellery,gift for her,natural stone,Tourmaline Rings,tourmaline necklace,rings for men,rings for women,jewellery making,jewellery supplies.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('710e78c3-5be9-420a-a5a5-701d209b61c3', '43.3 Cts tourmaline slices', 'unique tourmaline slices pairs


43.3 Cts 
10 to 13.5mm

Unheated, Untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 152, 1, 'loose_stone', 'Tourmaline', NULL, 43.3, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/710e78c3-5be9-420a-a5a5-701d209b61c3/etsy-1.jpg","https://media.gemworkers.com/items/710e78c3-5be9-420a-a5a5-701d209b61c3/etsy-2.jpg","https://media.gemworkers.com/items/710e78c3-5be9-420a-a5a5-701d209b61c3/etsy-3.jpg","https://media.gemworkers.com/items/710e78c3-5be9-420a-a5a5-701d209b61c3/etsy-4.jpg","https://media.gemworkers.com/items/710e78c3-5be9-420a-a5a5-701d209b61c3/etsy-5.jpg","https://media.gemworkers.com/items/710e78c3-5be9-420a-a5a5-701d209b61c3/etsy-6.jpg","https://media.gemworkers.com/items/710e78c3-5be9-420a-a5a5-701d209b61c3/etsy-7.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 170 USD, converted at ECB rate. Etsy tags: y2k earrings stud,Natural Stone,Tourmaline Earrings,Tourmaline Jewellery,Earrings Findings,Rings For Women,pink tourmaline,lagoon tourmaline,Blue tourmaline,tourmaline pairs,tourmaline lot,Tourmaline Slices,Slices Pairs.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('51b02dbb-f707-47be-9b13-7479716cb03c', '33.6 Cts tourmaline slices pairs', 'unique tourmaline slices pairs

33.60 Cts
12.5 to 16mm

Unheated, Untreated', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 152, 1, 'loose_stone', 'Tourmaline', NULL, 33.6, 'ct', NULL, NULL, NULL, '["https://media.gemworkers.com/items/51b02dbb-f707-47be-9b13-7479716cb03c/etsy-1.jpg","https://media.gemworkers.com/items/51b02dbb-f707-47be-9b13-7479716cb03c/etsy-2.jpg","https://media.gemworkers.com/items/51b02dbb-f707-47be-9b13-7479716cb03c/etsy-3.jpg","https://media.gemworkers.com/items/51b02dbb-f707-47be-9b13-7479716cb03c/etsy-4.jpg","https://media.gemworkers.com/items/51b02dbb-f707-47be-9b13-7479716cb03c/etsy-5.jpg","https://media.gemworkers.com/items/51b02dbb-f707-47be-9b13-7479716cb03c/etsy-6.jpg","https://media.gemworkers.com/items/51b02dbb-f707-47be-9b13-7479716cb03c/etsy-7.jpg","https://media.gemworkers.com/items/51b02dbb-f707-47be-9b13-7479716cb03c/etsy-8.jpg","https://media.gemworkers.com/items/51b02dbb-f707-47be-9b13-7479716cb03c/etsy-9.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 170 USD, converted at ECB rate. Etsy tags: y2k earrings stud,Natural Stone,Tourmaline Earrings,Tourmaline Jewellery,Earrings Findings,Rings For Women,pink tourmaline,lagoon tourmaline,Blue tourmaline,tourmaline pairs,tourmaline lot,Tourmaline Slices,Slices Pairs.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.inventory_items (id, title, description, seller_id, selling_price, quantity, product_type, gem_type, variety, weight_value, weight_unit, origin_country, clarity, dimensions_mm, image_urls, notes, sale_method, shipping_cost, delivery_days_min, delivery_days_max, prep_days, status, is_listed)
VALUES ('9013f4cf-5a8a-45c3-95c4-4ea9512bc713', '3.45 Cts Paraiba blue Tourmaline', 'Paraiba blue colour tourmaline 

mesmerising rare colour Afghan tourmaline.

3.45 cts
18.4 x 5.1 x 3.6mm

no treatment whatsoever.', 'f4b5d6e0-f2b5-475b-b294-acdcb5c51ecd', 267, 1, 'loose_stone', 'Tourmaline', 'Paraiba', 3.45, 'ct', 'Afghanistan', NULL, NULL, '["https://media.gemworkers.com/items/9013f4cf-5a8a-45c3-95c4-4ea9512bc713/etsy-1.jpg","https://media.gemworkers.com/items/9013f4cf-5a8a-45c3-95c4-4ea9512bc713/etsy-2.jpg","https://media.gemworkers.com/items/9013f4cf-5a8a-45c3-95c4-4ea9512bc713/etsy-3.jpg","https://media.gemworkers.com/items/9013f4cf-5a8a-45c3-95c4-4ea9512bc713/etsy-4.jpg","https://media.gemworkers.com/items/9013f4cf-5a8a-45c3-95c4-4ea9512bc713/etsy-5.jpg","https://media.gemworkers.com/items/9013f4cf-5a8a-45c3-95c4-4ea9512bc713/etsy-6.jpg","https://media.gemworkers.com/items/9013f4cf-5a8a-45c3-95c4-4ea9512bc713/etsy-7.jpg","https://media.gemworkers.com/items/9013f4cf-5a8a-45c3-95c4-4ea9512bc713/etsy-8.jpg","https://media.gemworkers.com/items/9013f4cf-5a8a-45c3-95c4-4ea9512bc713/etsy-9.jpg","https://media.gemworkers.com/items/9013f4cf-5a8a-45c3-95c4-4ea9512bc713/etsy-10.jpg"]'::jsonb, 'Imported from Etsy (2026-11-09). Etsy price 299 USD, converted at ECB rate. Etsy tags: Tourmaline Jewellery,Tourmaline Rings,Blue Tourmaline,Gift For Her,Rings For Women,Rings For Men,Gold Rings,Natural Stone,lagoon tourmaline,indigo tourmaline,indicolitetourmaline,Oceangemsminerals,ink blue tourmaline.', 'both', 0, 10, 20, NULL, 'available', false)
ON CONFLICT (id) DO NOTHING;
COMMIT;
