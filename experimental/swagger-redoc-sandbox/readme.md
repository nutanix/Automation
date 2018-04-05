# quick tester repo
Quick test repo for Jon's ReDoc doodling. Also posted to github pages to do rapid rendering and modeling

# ToDo and chase downs 
## RE DOC BUGS
* response objects
    * Schema $refs seem to be mutually exclusive with $ref’s to global response section
        * If I put in a $ref to the responses global object, such that I can “communize” my headers and other repetitive things, but then also do a schema $ref to a #/definitions/ schema object, ReDoc will not render both at the same time, but does not throw an error when loading the page
    * Header $refs only seem to pick up description
        * To test this, I put in two headers, one of them $ref’ing the entire object and the other manually enumerating the object. Both objects are exactly the same data. The $ref’d object only picks up description. The non $ref’d works as expected
* tags object
    * Doesn’t seem to support externalDocs on a per tag level. This would help to link to additional documentation, contextually from within each tag header. 
        * Swagger-ui seems to support this.
        * Interesting swagger validator trips this up, need to double check spec definition

## Stuff to track/change on the Nutanix side
* In various places, like last_update_time, the description keyword (when converted) had a strange line break, which is not needed (I don’t think), might be worth while to remove to cleanup
* Is ANY metadata ACTUALLY required on intent submission?
    * Try this out with a simple create VM call and see what it actually accepts (as DREDD will flag this anyways)
* In responses metadata, like vm_metadata
    * Is require (kind) actually required? Need to get clarity here
    * WE NEED TO BREAK THESE UP INTO REQUEST MODEL VS RESPONSE MODEL
* In request body schema, like vm_metadata
    * Why are UUID, spec_version, and spec_hash NOT set to read only? Can you actually “set” these if you did a POST?
    * WE NEED TO BREAK THESE UP INTO REQUEST MODEL VS RESPONSE MODEL
* Add a consumes section and flesh out consumes values
    * Specifically for oAuth, need to figure out what backend actually consumes, either  "application/x-www-form-urlencoded" or "multipart/form-data”
* In oauth parameters
    * Operations with Parameters of "in: formData" must include "application/x-www-form-urlencoded" or "multipart/form-data" in their "consumes" property
    * Update these parameters to either strip out formData (unlikely) or add a consumes section
    * Needs to be done in POST authorize and POST token
    * Default (what gets show automatically) appears to be url encoded but it needs to be sorted out
* Add tags global and tagGroups
    * Switch to ReDoc/tagGroups will require a change to x-doc-hide behavior, where we will simply switch anything not to be displayed to “hidden” as the tag value, and drop x-doc-hide completely
* Restructure YAML layout to match 2.0 spec pound for pound
* In various places, like /definitions/vm, the intent input spec properties are not ordered sanely
    * Example, its currently ordered description, resources, cluster_reference, name, avail
    * It should be modeled much like the UI is, where the name is first OR at least the REQUIRED fields are first, with alphabetic after that
    * Otherwise, in large models, it becomes difficult to eyeball whats needed from swagger-ui or ReDoc
* In various places where we return api_version, the default is NOT set (and some places it is)
    * To fix this, update all api_version spots in definition objects to $ref … 
$ref: '#/definitions/api_version'
    * Then make a definitions
        * api_version:
readOnly: true 
default: '3.1.0' 
type: string
    * This will save ~400++ lines in the YAML!! 
    * NOTE: Many places have this read only, and others done, leading to inconsistency in the request body schema, as it looks like you can actually submit the api_version, which makes very little sense to me. This should be read only everywhere
    * NOTE: This is in various “input” sections, like vm_intent_input, which seems silly. One would think that you just need spec and metadata and call it a day
* In our response codes, we string out the response code numbers (like ‘200’)
    * These can just be changed to int’s, as thats what they are
* imn our response objects: 
    * The Responses Object MUST contain at least one response code, and it SHOULD be the response for a successful operation call.
* In changed regions, there is a typo on description that messes up YAML formatting in editors (has close paren vs bracket)
    * List of regions describing the change for the interval [start_offset, next_offset).
* In paths - parameters, need to switch UUID references to "- $ref: '#/parameters/uuid’” (or xyz_uuid equiv)
    * This will reduce the total size of our YAML, which increases dev site performance
    * Should be able to do this for
        * KMS_uuid
        * NODE_uuid
    * Might be worth while to do it for anything in path, so it becomes a common dir for UUID for new API’s as they are added
        * Such as /fanout_proxy, has several UUID’d fields
* In definitions, new definition for uuid, and do a $ref JSON pointer 
    * Would still need to keep local description keyword:, so that you could contextualize this per response or wherever its called
    * This saves almost SIX HUNDRED lines of YAML on PE alone, and will only scale more over time!
    * $ref: '#/definitions/uuid'
    * pattern: '^[a-fA-F0-9]{8}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{12}$'
    * type: string
    * format: UUID
* In definitions
    * Add templates for generic headers for maximum reusability
    * Add generic response templates, where possible (like 403 forbidden), where the responses do not spit out KIND (this might be the only one)
* In responses
    * Add very generic ones, like 403/503?
* Figure out x-code-sample strategy, whether we want to maintain, or use the openapi generator that is in PR status right now
* Figure out external stylization, such that we can plumb in both PC 2.0's color and font schemes with the 509 redesign
