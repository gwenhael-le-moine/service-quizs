SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL';

DROP SCHEMA IF EXISTS `quizs` ;
CREATE SCHEMA IF NOT EXISTS `quizs` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
USE `quizs` ;

-- -----------------------------------------------------
-- Table `quizs`.`quizs`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `quizs`.`quizs` ;

CREATE  TABLE IF NOT EXISTS `quizs`.`quizs` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `created_at` DATETIME NULL ,
  `updated_at` DATETIME NULL ,
  `user_id` VARCHAR(8) NOT NULL COMMENT 'Propriétaire du quiz (utilisateur de l’ENT)' ,
  `title` VARCHAR(100) NULL ,
  `opt_show_score` ENUM('after_each', 'at_end', 'none') NOT NULL DEFAULT 'after_each' COMMENT 'Montrer le score après chaque question ou à la fin du quiz.' ,
  `opt_show_correct` ENUM('after_each', 'at_end', 'none') NOT NULL DEFAULT 'after_each' COMMENT 'Montrer la correction après chaque question ou à la fin du quiz.' ,
  `opt_can_redo` TINYINT(1) NOT NULL DEFAULT 1 COMMENT 'Possibilité de refaire plusieurs fois le quiz' ,
  `opt_can_rewind` TINYINT(1) NOT NULL DEFAULT 1 ,
  `opt_rand_question_order` TINYINT(1) NOT NULL DEFAULT 0 COMMENT 'mélanger l’ordre des questions.' ,
  `opt_shared` TINYINT(1) NOT NULL DEFAULT 0 COMMENT 'quiz partagé ou non : i.e. visible des autres utilisateurs (auteurs de quizz) de l’ENT.' ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;


-- -----------------------------------------------------
-- Table `quizs`.`medias`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `quizs`.`medias` ;

CREATE  TABLE IF NOT EXISTS `quizs`.`medias` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `created_at` DATETIME NULL ,
  `name` VARCHAR(250) NULL ,
  `content_type` VARCHAR(100) NOT NULL ,
  `uri` VARCHAR(2000) NOT NULL ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;


-- -----------------------------------------------------
-- Table `quizs`.`questions`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `quizs`.`questions` ;

CREATE  TABLE IF NOT EXISTS `quizs`.`questions` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `quiz_id` INT NOT NULL ,
  `type` ENUM('QCM','TAT','ASS') NOT NULL COMMENT 'type de question QCM, TAT (textes à trous) ou ASS (associations).' ,
  `question` VARCHAR(256) NOT NULL COMMENT 'Intitulé de la question' ,
  `hint` VARCHAR(2000) NULL COMMENT 'Aide sur la question ' ,
  `correction_comment` VARCHAR(2000) NULL COMMENT 'commentaire de correction' ,
  `order` INT NOT NULL COMMENT 'Ordre d’apparition de la question dans le déroulement du quiz.' ,
  `medium_id` INT NULL ,
  `opt_rand_suggestion_order` TINYINT(1) NOT NULL DEFAULT 0 COMMENT 'mélanger l’ordre des propositions de réponses.' ,
  PRIMARY KEY (`id`) ,
  INDEX `fk_question_quiz_idx` (`quiz_id` ASC) ,
  INDEX `fk_question_medium1_idx` (`medium_id` ASC) ,
  CONSTRAINT `fk_question_quiz`
    FOREIGN KEY (`quiz_id` )
    REFERENCES `quizs`.`quizs` (`id` )
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_question_medium1`
    FOREIGN KEY (`medium_id` )
    REFERENCES `quizs`.`medias` (`id` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;


-- -----------------------------------------------------
-- Table `quizs`.`suggestions`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `quizs`.`suggestions` ;

CREATE  TABLE IF NOT EXISTS `quizs`.`suggestions` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `question_id` INT NOT NULL ,
  `text` VARCHAR(2000) NOT NULL ,
  `order` INT NULL ,
  `medium_id` INT NULL ,
  `position` ENUM('L','R') NOT NULL DEFAULT 'L' COMMENT 'Position de la proposition de réponse (gauche ou droite).Seuls les associations ont des propositions de type ‘Droite’ en plus des propositions de gauche.' ,
  PRIMARY KEY (`id`) ,
  INDEX `fk_answer_proposition_question1_idx` (`question_id` ASC) ,
  INDEX `fk_answer_proposition_medium1_idx` (`medium_id` ASC) ,
  CONSTRAINT `fk_answer_proposition_question1`
    FOREIGN KEY (`question_id` )
    REFERENCES `quizs`.`questions` (`id` )
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_answer_proposition_medium1`
    FOREIGN KEY (`medium_id` )
    REFERENCES `quizs`.`medias` (`id` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;


-- -----------------------------------------------------
-- Table `quizs`.`solutions`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `quizs`.`solutions` ;

CREATE  TABLE IF NOT EXISTS `quizs`.`solutions` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `left_suggestion_id` INT NOT NULL COMMENT 'Table des solutions pour les QCM et TAT  (la présence d’une valeur dans ‘left_answer_prop_id’ suffit à identifier que cette proposition est la bonne solution), pour les Associations, la solution est la relation entre 2 propositions.' ,
  `right_suggestion_id` INT NULL ,
  INDEX `fk_association_answer_proposition1_idx` (`left_suggestion_id` ASC) ,
  INDEX `fk_association_answer_proposition2_idx` (`right_suggestion_id` ASC) ,
  PRIMARY KEY (`id`) ,
  CONSTRAINT `fk_association_answer_proposition1`
    FOREIGN KEY (`left_suggestion_id` )
    REFERENCES `quizs`.`suggestions` (`id` )
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_association_answer_proposition2`
    FOREIGN KEY (`right_suggestion_id` )
    REFERENCES `quizs`.`suggestions` (`id` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;


-- -----------------------------------------------------
-- Table `quizs`.`publications`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `quizs`.`publications` ;

CREATE  TABLE IF NOT EXISTS `quizs`.`publications` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `quiz_id` INT NOT NULL ,
  `from_date` DATETIME NULL ,
  `to_date` DATETIME NULL ,
  `rgpt_id` INT NOT NULL COMMENT 'Clé étrangère sur l’identifiant d’une classe ou d’un groupe d’élèves.' ,
  `opt_show_score` ENUM('after_each', 'at_end', 'none') NOT NULL DEFAULT 'after_each' COMMENT 'Montrer le score après chaque question ou à la fin du quiz.' ,
  `opt_show_correct` ENUM('after_each', 'at_end', 'none') NOT NULL DEFAULT 'after_each' COMMENT 'Montrer la correction après chaque question ou à la fin du quiz.' ,
  `opt_can_redo` TINYINT(1) NOT NULL DEFAULT 1 COMMENT 'Possibilité de refaire plusieurs fois le quiz' ,
  `opt_can_rewind` TINYINT(1) NOT NULL DEFAULT 1 ,
  `opt_rand_question_order` TINYINT(1) NOT NULL DEFAULT 0 COMMENT 'mélanger l’ordre des questions.' ,
  PRIMARY KEY (`id`) ,
  INDEX `fk_publication_quiz1_idx` (`quiz_id` ASC) ,
  CONSTRAINT `fk_publication_quiz1`
    FOREIGN KEY (`quiz_id` )
    REFERENCES `quizs`.`quizs` (`id` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;


-- -----------------------------------------------------
-- Table `quizs`.`sessions`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `quizs`.`sessions` ;

CREATE  TABLE IF NOT EXISTS `quizs`.`sessions` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `quiz_id` INT NOT NULL ,
  `user_id` VARCHAR(8) NOT NULL COMMENT 'Clé étrangère vers l’identifiant de l’élève en session' ,
  `user_type` VARCHAR(45) NOT NULL ,
  `created_at` DATETIME NOT NULL COMMENT 'Date de début de la session de l’élève' ,
  `updated_at` DATETIME NULL COMMENT 'Fin de la session (la dernière fois où il en envoyé des données de réponse)' ,
  `score` FLOAT NOT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `fk_sessions_quizs1` (`quiz_id` ASC) ,
  CONSTRAINT `fk_sessions_quizs1`
    FOREIGN KEY (`quiz_id` )
    REFERENCES `quizs`.`quizs` (`id` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;


-- -----------------------------------------------------
-- Table `quizs`.`answers`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `quizs`.`answers` ;

CREATE  TABLE IF NOT EXISTS `quizs`.`answers` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `session_id` INT NOT NULL ,
  `left_suggestion_id` INT NOT NULL COMMENT 'Réponses des élèves pour les QCM et TAT  (la présence d’une valeur dans ‘left_suggestion_id’ suffit à identifier la réponse de l’élève), pour les Associations, la réponse est la relation entre 2 suggestions.' ,
  `right_suggestion_id` INT NULL ,
  `created_at` DATETIME NULL ,
  INDEX `fk_answer_suggestion1_idx` (`left_suggestion_id` ASC) ,
  INDEX `fk_answer_session1_idx` (`session_id` ASC) ,
  INDEX `fk_answer_suggestion2_idx` (`right_suggestion_id` ASC) ,
  PRIMARY KEY (`id`) ,
  CONSTRAINT `fk_answer_suggestion1`
    FOREIGN KEY (`left_suggestion_id` )
    REFERENCES `quizs`.`suggestions` (`id` )
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_answer_session1`
    FOREIGN KEY (`session_id` )
    REFERENCES `quizs`.`sessions` (`id` )
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_answer_suggestion2`
    FOREIGN KEY (`right_suggestion_id` )
    REFERENCES `quizs`.`suggestions` (`id` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;



SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
