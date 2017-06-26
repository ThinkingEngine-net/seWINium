<?php

use Behat\Behat\Context\Context;
use Behat\Gherkin\Node\PyStringNode;
use Behat\Gherkin\Node\TableNode;
use Behat\MinkExtension\Context\MinkContext;

/**
 * Defines application features from the specific context.
 */
class FeatureContext extends MinkContext
{
    /**
     * Initializes context.
     *
     * Every scenario gets its own context instance.
     * You can also pass arbitrary arguments to the
     * context constructor through behat.yml.
     */
    public function __construct()
    {
    }

    /**
    * @Given /^the property "([^"]*)" in the JSON matches "([^"]*)"$/
    */
    public function iMatchProperty($prop, $text)
    {
        //$session =$this->getSession();
        //$page = $session->getPage();

        //$pageText= $page->getText();
        $pageText=$this->getSession()->getDriver()->getContent();


        preg_match_all('/\"'.$prop.'\"\s{0,1}\:\s{0,1}\"'.$text.'\"/',$pageText,$matches);

        if ($matches===false || count($matches[0])==0)
        {
            throw new \Exception("Could not find property '".$prop."' or the value did match '".$text."'.\r\n".$pageText."\r\n");
        }

        //var_dump($matches);

    }
}
