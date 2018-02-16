-- Dumping structure for table heroku_d0c1d8b62051b18.krms
CREATE TABLE IF NOT EXISTS `krms` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `client_id` int(11) DEFAULT NULL,
  `keywords` varchar(1000) DEFAULT NULL,
  `date` datetime DEFAULT NULL,
  `page_rank` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_krms_on_client_id` (`client_id`),
  CONSTRAINT `fk_rails_8094d2471e` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;

