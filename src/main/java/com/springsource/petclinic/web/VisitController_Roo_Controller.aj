// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package com.springsource.petclinic.web;

import com.springsource.petclinic.domain.Pet;
import com.springsource.petclinic.domain.Vet;
import com.springsource.petclinic.domain.Visit;
import com.springsource.petclinic.web.VisitController;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;
import org.joda.time.format.DateTimeFormat;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.util.UriUtils;
import org.springframework.web.util.WebUtils;

privileged aspect VisitController_Roo_Controller {
    
    @RequestMapping(method = RequestMethod.POST, produces = "text/html")
    public String VisitController.create(@Valid Visit visit, BindingResult bindingResult, Model uiModel, HttpServletRequest httpServletRequest) {
        if (bindingResult.hasErrors()) {
            populateEditForm(uiModel, visit);
            return "visits/create";
        }
        uiModel.asMap().clear();
        visit.persist();
        return "redirect:/visits/" + encodeUrlPathSegment(visit.getId().toString(), httpServletRequest);
    }
    
    @RequestMapping(params = "form", produces = "text/html")
    public String VisitController.createForm(Model uiModel) {
        populateEditForm(uiModel, new Visit());
        List<String[]> dependencies = new ArrayList<String[]>();
        if (Pet.countPets() == 0) {
            dependencies.add(new String[] { "pet", "pets" });
        }
        uiModel.addAttribute("dependencies", dependencies);
        return "visits/create";
    }
    
    @RequestMapping(value = "/{id}", produces = "text/html")
    public String VisitController.show(@PathVariable("id") Long id, Model uiModel) {
        addDateTimeFormatPatterns(uiModel);
        uiModel.addAttribute("visit", Visit.findVisit(id));
        uiModel.addAttribute("itemId", id);
        return "visits/show";
    }
    
    @RequestMapping(produces = "text/html")
    public String VisitController.list(@RequestParam(value = "page", required = false) Integer page, @RequestParam(value = "size", required = false) Integer size, Model uiModel) {
        if (page != null || size != null) {
            int sizeNo = size == null ? 10 : size.intValue();
            final int firstResult = page == null ? 0 : (page.intValue() - 1) * sizeNo;
            uiModel.addAttribute("visits", Visit.findVisitEntries(firstResult, sizeNo));
            float nrOfPages = (float) Visit.countVisits() / sizeNo;
            uiModel.addAttribute("maxPages", (int) ((nrOfPages > (int) nrOfPages || nrOfPages == 0.0) ? nrOfPages + 1 : nrOfPages));
        } else {
            uiModel.addAttribute("visits", Visit.findAllVisits());
        }
        addDateTimeFormatPatterns(uiModel);
        return "visits/list";
    }
    
    @RequestMapping(method = RequestMethod.PUT, produces = "text/html")
    public String VisitController.update(@Valid Visit visit, BindingResult bindingResult, Model uiModel, HttpServletRequest httpServletRequest) {
        if (bindingResult.hasErrors()) {
            populateEditForm(uiModel, visit);
            return "visits/update";
        }
        uiModel.asMap().clear();
        visit.merge();
        return "redirect:/visits/" + encodeUrlPathSegment(visit.getId().toString(), httpServletRequest);
    }
    
    @RequestMapping(value = "/{id}", params = "form", produces = "text/html")
    public String VisitController.updateForm(@PathVariable("id") Long id, Model uiModel) {
        populateEditForm(uiModel, Visit.findVisit(id));
        return "visits/update";
    }
    
    @RequestMapping(value = "/{id}", method = RequestMethod.DELETE, produces = "text/html")
    public String VisitController.delete(@PathVariable("id") Long id, @RequestParam(value = "page", required = false) Integer page, @RequestParam(value = "size", required = false) Integer size, Model uiModel) {
        Visit visit = Visit.findVisit(id);
        visit.remove();
        uiModel.asMap().clear();
        uiModel.addAttribute("page", (page == null) ? "1" : page.toString());
        uiModel.addAttribute("size", (size == null) ? "10" : size.toString());
        return "redirect:/visits";
    }
    
    void VisitController.addDateTimeFormatPatterns(Model uiModel) {
        uiModel.addAttribute("visit_visitdate_date_format", DateTimeFormat.patternForStyle("M-", LocaleContextHolder.getLocale()));
    }
    
    void VisitController.populateEditForm(Model uiModel, Visit visit) {
        uiModel.addAttribute("visit", visit);
        addDateTimeFormatPatterns(uiModel);
        uiModel.addAttribute("pets", Pet.findAllPets());
        uiModel.addAttribute("vets", Vet.findAllVets());
    }
    
    String VisitController.encodeUrlPathSegment(String pathSegment, HttpServletRequest httpServletRequest) {
        String enc = httpServletRequest.getCharacterEncoding();
        if (enc == null) {
            enc = WebUtils.DEFAULT_CHARACTER_ENCODING;
        }
        try {
            pathSegment = UriUtils.encodePathSegment(pathSegment, enc);
        } catch (UnsupportedEncodingException uee) {}
        return pathSegment;
    }
    
}
